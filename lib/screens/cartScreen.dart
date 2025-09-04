import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UX/Database/DBHelper.dart';
import '../UX/Providers/orderProvider.dart';
import '../helpers/widgets.dart';
import 'homeScreen.dart';

class cartScreen extends StatefulWidget {
  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  TextEditingController _addressontroller = TextEditingController();
  TextEditingController _noController = TextEditingController();
  bool _isLoading = false; // <-- Loading state

  @override
  Widget build(BuildContext context) {
    List<OrderedProduct> _products =
    context.watch<orderProvider>().getOrderProducts();

    return Scaffold(
      backgroundColor: Color(0xFFFFFFF0),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
        child: Column(
          children: [
            Expanded(
              child: _products.isEmpty
                  ? Center(
                child: MontserratTextWidget(
                  text: "Your cart is empty",
                  color: Colors.black,
                  size: 18,
                  weight: FontWeight.w600,
                ),
              )
                  : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final item = _products[index];
                  return InkWell(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => RemoveConfirmationDialog(
                          productName: item.name,
                          onConfirm: () {
                            context
                                .read<orderProvider>()
                                .removeProductFromOrder(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${item.name} removed from cart'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: ItemInCart(
                      index: index,
                      title: item.name,
                      size: item.size,
                      price: item.price,
                      imageUrl: item.imageUrl,
                      quantity: item.quantity,
                      bill: item.bill,
                    ),
                  );
                },
              ),
            ),
            if (_products.isNotEmpty)
              Column(
                children: [
                  Divider(),
                  LogoTextField(
                    icon: Icons.home_outlined,
                    hintText: "Enter your address",
                    textColor: Colors.black,
                    iconColor: Color(0xFFC67C4E),
                    backgroundColor: Colors.white,
                    controller: _addressontroller,
                  ),
                  LogoTextField(
                    icon: Icons.phone,
                    hintText: "Enter your phone number",
                    textColor: Colors.black,
                    iconColor: Color(0xFFC67C4E),
                    backgroundColor: Colors.white,
                    controller: _noController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MontserratTextWidget(
                        text: "Total",
                        color: Colors.black,
                        size: 18,
                        weight: FontWeight.w600,
                      ),
                      Consumer<orderProvider>(
                        builder: (context, provider, _) {
                          return MontserratTextWidget(
                            text:
                            "\$${context.watch<orderProvider>().getTotalBill()}",
                            color: Colors.black,
                            size: 18,
                            weight: FontWeight.w600,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFC67C4E),
                    ),
                  )
                      : CustomElevatedButton(
                    text: "Place Order",
                    onPressed: () async {
                      String address = _addressontroller.text.trim();
                      String phone = _noController.text.trim();

                      if (address.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                              Text('Please enter your address')),
                        );
                        return;
                      }

                      if (phone.length != 11 ||
                          !RegExp(r'^[0-9]+$').hasMatch(phone)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Phone number must be exactly 11 digits')),
                        );
                        return;
                      }

                      // Show loading
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await context.read<orderProvider>().placeOrder(
                          context,
                          context
                              .read<orderProvider>()
                              .getTotalBill(),
                          address,
                          phone,
                        );
                      } finally {
                        // Hide loading after process is done
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    width: double.infinity,
                    height:
                    MediaQuery.of(context).size.height * 0.07,
                    backgroundColor: Color(0xFFC67C4E),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

