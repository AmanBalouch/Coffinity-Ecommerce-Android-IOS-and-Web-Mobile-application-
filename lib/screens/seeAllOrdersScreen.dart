import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UX/Database/DBHelper.dart';
import '../UX/Providers/orderProvider.dart';
import '../helpers/widgets.dart';

class seeAllOrdersScreen extends StatefulWidget {
  @override
  State<seeAllOrdersScreen> createState() => _seeOrderInProcessScreenState();
}

class _seeOrderInProcessScreenState extends State<seeAllOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<orderProvider>();
      await provider.LoadAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Order> _allOrders = context.watch<orderProvider>().getAllOrders();
    print(_allOrders.length);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF0),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                children: [
                  Expanded(
                    child: _allOrders.isEmpty
                        ? Center(
                      child: MontserratTextWidget(
                        text: "Zero Order",
                        color: Colors.black,
                        size: 18,
                        weight: FontWeight.w600,
                      ),
                    )
                        : ListView.builder(
                      itemCount: _allOrders.length,
                      itemBuilder: (context, index) {
                        final item = _allOrders[index];
                        return OrderUIWidget(order: item);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Back button
            Positioned(
              top: 10,
              left: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
