import 'package:coffeemobileapplicationandroid/helpers/widgets.dart';
import 'package:coffeemobileapplicationandroid/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class splashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF230C02),
              Color(0x9D230C02),
              Color(0x00230C02),
            ],
            stops: [0.459, 0.6825, 0.951],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Find your Favorite",style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700, // Bold
              color: Colors.white)
              ),
              ),
            InterTextWidget(text: "Coffee Taste!", color: Colors.white, size: 34, weight:FontWeight.w700),
            SizedBox(height: MediaQuery.of(context).size.height*0.02,),
            MontserratTextWidget(
              text: "We’re coffe shop, bee and wine bar, and event",
                color: Colors.white,
                size: 12,
                weight: FontWeight.w400),
            MontserratTextWidget(
                text: "Space for performing art",
                color: Colors.white,
                size: 12,
                weight: FontWeight.w400),
            SizedBox(height:MediaQuery.of(context).size.height * 0.03),
            CustomElevatedButton(
              text: "Get Started",
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>loginScreen()));
              },
              width: MediaQuery.of(context).size.width * 0.5,
              height:MediaQuery.of(context).size.height * 0.06,
              backgroundColor: Color(0xFFC67C4E),
              textColor: Colors.white,
              fontSize: 16,
              icon: Icons.arrow_forward_ios,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.15)
          ],
        ),
        ),
    );
  }
}
