import 'package:coffeemobileapplicationandroid/UX/Providers/orderProvider.dart';
import 'package:coffeemobileapplicationandroid/helpers/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String size;
  final String price;
  final double rating;
  final String imageUrl;
  final String desc;

  const DetailScreen({
    super.key,
    required this.title,
    required this.size,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.desc,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isExpanded = false;
  bool _showReadMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final span = TextSpan(
      text: widget.desc,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
    );

    final tp = TextPainter(
      text: span,
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    tp.layout(maxWidth: MediaQuery.of(context).size.width - 60);

    if (tp.didExceedMaxLines) {
      setState(() {
        _showReadMore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 1, 30, 5),
          child: SafeArea(
            child: Column(
              children: [
                // ---------- IMAGE AND STACK SECTION ----------
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.imageUrl,
                        height: MediaQuery.of(context).size.height * 0.70,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: MediaQuery.of(context).size.height * 0.70,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Material(
                          color: Colors.transparent, // Transparent to only show ripple on icon
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50), // Optional: for circular ripple
                            onTap: () {
                              Navigator.pop(context); // Or any custom action
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0), // Increases touch area
                              child: Icon(Icons.arrow_back, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.86,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF4F372F),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InterTextWidgetForDot(
                              text: widget.title,
                              color: Colors.white,
                              size: 32,
                              weight: FontWeight.w600,
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Color(0xFFFEA922), size: 11),
                                SizedBox(width: 4),
                                Text(
                                  widget.rating.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "(2,453 Review)",
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            InterTextWidgetForDot(
                              text: widget.price,
                              color: Colors.white,
                              size: 32,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 40,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.favorite_border, color: Colors.brown),
                          ),
                          SizedBox(height: 10),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.share, color: Colors.brown),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ---------- DESCRIPTION SECTION ----------
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MontserratTextWidget(
                    text: "Description",
                    color: Colors.black,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.desc,
                  maxLines: _isExpanded ? null : 2,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
                if (_showReadMore)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? "Read Less..." : "Read More...",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                if (!_isExpanded) ...[
                  SizedBox(height: MediaQuery.of(context).size.height*0.04),
                  CustomElevatedButton(
                      text: "Add Order",
                      onPressed: () {
                        context.read<orderProvider>().addProductToOrder(
                            name: widget.title,
                            size: widget.size,
                          price: double.parse(widget.price.replaceAll("\$", "")),
                          quantity: 1,
                            bill:  double.parse(widget.price.replaceAll("\$", "")),
                            imageUrl: widget.imageUrl,);
                        context.read<orderProvider>().addInTotalBill(double.parse(widget.price.replaceAll("\$", "")));
                      },
                      width: double.infinity,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08,
                      backgroundColor: Color(0xFFC67C4E),
                      textColor: Colors.white,
                      fontSize: 16,
                      borderColor: Colors.white
                  ),
                ] else
                  SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
