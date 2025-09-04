import 'package:coffeemobileapplicationandroid/UX/Providers/DBProvider.dart';
import 'package:coffeemobileapplicationandroid/UX/Providers/orderProvider.dart';
import 'package:coffeemobileapplicationandroid/screens/cartScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/detailScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/homeScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/profileScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/seeOrderInProcessScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../UX/Database/DBHelper.dart';

class InterTextWidget extends StatelessWidget {
  late String text;
  late double size;
  late FontWeight weight;
  late Color color;
  InterTextWidget({required this.text,required this.color,required this.size,required this.weight});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
          textStyle: TextStyle(
              fontSize: size,
              fontWeight: weight, // Bold
              color: color)
      ),
    );
  }
}

class MontserratTextWidget extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;

  MontserratTextWidget({
    required this.text,
    required this.color,
    required this.size,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: color,
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final IconData? icon;
  final Color? borderColor; // ✅ Optional border color

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 46,
    this.icon,
    this.borderColor, // ✅ Add to constructor
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none, // ✅ Optional border
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InterTextWidget(
              text: text,
              size: fontSize,
              weight: fontWeight,
              color: textColor,
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: fontSize + 2),
            ]
          ],
        ),
      ),
    );
  }
}


class LogoTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final double borderRadius;
  final TextEditingController? controller;
  final bool isPassword;

  const LogoTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.textColor,
    required this.iconColor,
    required this.backgroundColor,
    this.borderRadius = 12.0,
    this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _LogoTextFieldState createState() => _LogoTextFieldState();
}

class _LogoTextFieldState extends State<LogoTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      style: GoogleFonts.inter(color: widget.textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: widget.iconColor),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.inter(
          color: widget.textColor.withOpacity(0.6),
          fontSize: 16,
        ),
        filled: true,
        fillColor: widget.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: widget.iconColor,
          ),
          onPressed: _toggleVisibility,
        )
            : null,
      ),
    );
  }
}


class CustomTextButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.all(textColor.withOpacity(0.1)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: InterTextWidget(
        text: text,
        color: textColor,
        size: fontSize,
        weight: fontWeight,
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onPressed;


  const SearchTextField({
    Key? key,
    this.controller,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.iconBackgroundColor = const Color(0xFFDEE9FF),
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(
        color: textColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Find your Coffee...',
        hintStyle: GoogleFonts.inter(
          color: textColor.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.w500
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: iconBackgroundColor,
            child: Material(
              color: Colors.transparent, // So it blends with background
              child: InkWell(
                borderRadius: BorderRadius.circular(30), // Optional: for ripple shape
                onTap: () {
                  onPressed;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Makes it easier to tap
                  child: Icon(
                    Icons.search,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}

class CategoryRow extends StatefulWidget {
  @override
  _CategoryRowState createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load categories once at the beginning
    Future.microtask(() {
      context.read<DBProvider>().allCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DBProvider>();
    final categories = provider.getCategories();
    final isLoading = provider.getIsLoading();

    return isLoading
        ? Center(child: CircularProgressIndicator()) // Show loader while switching category
        : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(categories.length, (index) {
          bool isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: isSelected
                ? ElevatedButton(
              onPressed: () async {
                setState(() {
                  selectedIndex = index;
                });
                await context
                    .read<DBProvider>()
                    .productsByCategory(categories[index]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC67C4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: MontserratTextWidget(
                  text: categories[index],
                  color: Colors.white,
                  size: 16,
                  weight: FontWeight.w600),
            )
                : GestureDetector(
              onTap: () async {
                setState(() {
                  selectedIndex = index;
                });
                await context
                    .read<DBProvider>()
                    .productsByCategory(categories[index]);
              },
              child: MontserratTextWidget(
                  text: categories[index],
                  color: Color(0xFFB9B9B9),
                  size: 16,
                  weight: FontWeight.w600),
            ),
          );
        }),
      ),
    );
  }
}

class NoticeBox extends StatelessWidget {
  final String message;
  final Color bgColor;

  const NoticeBox({
    Key? key,
    required this.message,
    this.bgColor = Colors.redAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final String title;
  final String size;
  final String price;
  final double rating;
  final String desc;
  final String imageUrl;

  const ProductCardWidget({
    required this.title,
    required this.size,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        height: MediaQuery.of(context).size.height * 0.28,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.009),
              InterTextWidgetForDot(
                text: title,
                color: Colors.black,
                size: 16,
                weight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text("Size : $size", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFC67C4E),
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Colors.transparent, // keep the background unchanged
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
                                title: title,
                                size: size,
                                price: price,
                                rating: rating,
                                imageUrl: imageUrl,
                                desc: desc,
                              ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return ScaleTransition(
                                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutBack, // smooth pop effect
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularItemCard extends StatelessWidget {
  final String title;
  final String size;
  final String price;
  final String imageUrl;
  final double rating;
  final String desc;

  const PopularItemCard({
    required this.title,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.desc
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width*0.15,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width*0.15,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                  Text("Size : $size", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Text(price, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC67C4E))),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFC67C4E),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent, // keep the background unchanged
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
                          title: title,
                          size: size,
                          price: price,
                          rating: rating,
                          imageUrl: imageUrl,
                          desc: desc,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutBack, // smooth pop effect
                              ),
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterTextWidgetForDot extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final int? maxLines;
  final TextOverflow? overflow;

  const InterTextWidgetForDot({
    required this.text,
    required this.color,
    required this.size,
    required this.weight,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;

  CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Optional: Navigate to different screens here
    // Example: Navigator.push(...)
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Color(0xFFB06F40);
    final inactiveColor = Colors.grey;

    return Container(
        height:MediaQuery.of(context).size.height * 0.075,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0 ? activeColor : inactiveColor),
                iconSize: 40,
            onPressed: () {
              _onItemTapped(0);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homeScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_bag,
                color: _selectedIndex == 1 ? activeColor : inactiveColor),
            iconSize: 40,
            onPressed: () {
              _onItemTapped(1);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>cartScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications,
                color: _selectedIndex == 2 ? activeColor : inactiveColor),
            iconSize: 40,
            onPressed: () {
              _onItemTapped(1);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>seeOrderInProcessScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.person,
                color: _selectedIndex == 3 ? activeColor : inactiveColor),
            iconSize: 40,
            onPressed: () {
              _onItemTapped(1);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>profileScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class ItemInCart extends StatefulWidget {
  final int index;
  final String title;
  final String size;
  final double price;
  double bill;
  final String imageUrl;
  int quantity;

  ItemInCart({
    required this.index,
    required this.title,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.bill,
  });

  @override
  State<ItemInCart> createState() => _ItemInCartState();
}

class _ItemInCartState extends State<ItemInCart> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.imageUrl,
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width*0.15,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width*0.15,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                  Text("Size : ${widget.size}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Text("\$${widget.bill}", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC67C4E))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Text("Quantity:${widget.quantity}", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC67C4E))),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if(widget.quantity>1) {
                            // setState(() {
                            //   widget.bill = widget.bill - widget.price;
                            //   widget.quantity -= 1;
                            //   print(widget.bill);
                            // });
                            context.read<orderProvider>().minusBillAndQuantity(widget.index);
                            context.read<orderProvider>().minusInTotalBill(widget.price);
                          }
                        },
                        borderRadius: BorderRadius.circular(20), // optional for ripple shape
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.remove_circle_outline, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   widget.bill=widget.bill + widget.price;
                          //   widget.quantity+=1;
                          // });
                          context.read<orderProvider>().addBillAndQuantity(widget.index);
                          context.read<orderProvider>().addInTotalBill(widget.price);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.add_circle, color: Color(0xFFC67C4E)),
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RemoveConfirmationDialog extends StatelessWidget {
  final String productName;
  final VoidCallback onConfirm;

  const RemoveConfirmationDialog({
    Key? key,
    required this.productName,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Item'),
      content: Text('Do you want to remove "$productName" from the cart?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: Text('Remove'),
        ),
      ],
    );
  }
}

class OrderUIWidget extends StatelessWidget {
  final Order order;

  OrderUIWidget({required this.order});

  String getStatusLabel(int status) {
    switch (status) {
      case 0:
        return "In Process";
      case 1:
        return "Completed";
      case 2:
        return "Cancelled";
      default:
        return "Unknown";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
    DateFormat('dd MMM yyyy • hh:mm a').format(order.orderDate);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Tooltip(
                      message: order.orderId,
                      child: Text(
                        'Order ID: ${order.orderId}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.01),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),

              /// 🧺 Products List
              ...order.products.map((p) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    p.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(p.name),
                subtitle: Text('Size: ${p.size}  |  Qty: ${p.quantity}'),
                trailing: Text('\$${p.bill.toStringAsFixed(2)}'),
              )),

              Divider(),

              /// 📦 Address, Phone, Total, Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Tooltip(
                          message: order.address,
                          child: Text(
                            order.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("Phone:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Tooltip(
                          message: order.phoneNo,
                          child: Text(
                            order.phoneNo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Total Bill",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        "\$${order.totalBill.toStringAsFixed(2)}",
                        style: TextStyle(color: Color(0xFFC67C4E)),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getStatusLabel(order.status),
                          style: TextStyle(
                            color: getStatusColor(order.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
