import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UX/Database/DBHelper.dart';
import '../UX/Providers/orderProvider.dart';
import '../helpers/widgets.dart';

class seeOrderInProcessScreen extends StatefulWidget {
  @override
  State<seeOrderInProcessScreen> createState() =>
      _seeOrderInProcessScreenState();
}

class _seeOrderInProcessScreenState extends State<seeOrderInProcessScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<orderProvider>();
      await provider.LoadInProcessOrders();
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Order> _inProcessOrders = context.watch<orderProvider>().getOrdersInProcess();
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF0),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
        child: Column(
          children: [
            Expanded(
              child:
                  _inProcessOrders.isEmpty
                      ? Center(
                        child: MontserratTextWidget(
                          text: "Not any order in Process",
                          color: Colors.black,
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                      )
                      : ListView.builder(
                        itemCount: _inProcessOrders.length,
                        itemBuilder: (context, index) {
                          final item = _inProcessOrders[index];
                          return OrderUIWidget(order: _inProcessOrders[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
