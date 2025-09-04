import 'package:coffeemobileapplicationandroid/UX/Providers/DBProvider.dart';
import 'package:coffeemobileapplicationandroid/screens/seeAllOrdersScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UX/Database/DBHelper.dart';
import '../UX/Providers/orderProvider.dart';
import '../helpers/widgets.dart';

class profileScreen extends StatefulWidget {
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  String _username="";

  String _email="";
  Future<void> loadUserData() async {
    _username=await DBHelper.getuserName();
    _email=await DBHelper.getEmail();
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    Future.microtask(() async {
      final provider = context.read<orderProvider>();
      await provider.LoadAllOrders();
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Order> _allOrders = context.watch<orderProvider>().getAllOrders();
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF0),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE3A481),
                  child:InterTextWidget(
                      text: _username.isNotEmpty ? _username[0].toUpperCase() : '?',
                      color: Colors.white,
                      size: 50,
                      weight:FontWeight.w600),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Center(
                child: Text(
                  _username,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Center(
                child: Text(
                  _email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Divider(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                children: [
                  InterTextWidget(
                      text: "Total Orders",
                      color: Colors.black,
                      size: 20,
                      weight:FontWeight.w600),
                  Spacer(),
                  InterTextWidget(
                      text: "${_allOrders.length}",
                      color: Colors.black,
                      size: 20,
                      weight:FontWeight.w600),
                ],
              ),
              SizedBox(height:  MediaQuery.of(context).size.height*0.05),
              Center(
                child: CustomElevatedButton(
                    text: "See all Orders",
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>seeAllOrdersScreen()));
                    },
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.09,
                    backgroundColor:Color(0xFFC67C4E),
                    textColor: Colors.white,
                    fontSize: 20),
              ),
              SizedBox(height:  MediaQuery.of(context).size.height*0.01),
              Center(
                child: CustomElevatedButton(
                    text: "Log out",
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("login", false);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>splashScreen()));
                    },
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.09,
                    backgroundColor:Colors.black,
                    textColor: Colors.white,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
