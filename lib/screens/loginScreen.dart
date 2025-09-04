import 'package:coffeemobileapplicationandroid/screens/forgotPasswordScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/homeScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/signUpScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/splashScreen1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UX/Providers/authProvider.dart';
import '../UX/loginSignUp.dart';
import '../helpers/widgets.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController _usernameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _showNotice=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // This disables auto-resizing
      // backgroundColor:Color(0xFF230C02),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30,MediaQuery.of(context).size.height*0.15 , 30, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  if (_showNotice)
                    NoticeBox(
                      message: context.watch<authProvider>().getMessage(),
                      bgColor: Colors.redAccent,
                    ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                    ],
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: InterTextWidget(text: "Hi,\nWelcome Back!",
                          color: Colors.white,
                          size: 34,
                          weight: FontWeight.w700)),
                  SizedBox(height: 42),
                  LogoTextField(
                    icon: Icons.person,
                    hintText: "Userame",
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    backgroundColor: Color(0xFF3A2921),
                    borderRadius: 16,
                    controller: _usernameController,
                  ),
                  SizedBox(height: 25,),
                  LogoTextField(
                    icon: Icons.password,
                    hintText: "password",
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    backgroundColor: Color(0xFF3A2921),
                    borderRadius: 16,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextButton(
                        text: 'Forgot Password?',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>forgotPasswordScreen()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  CustomElevatedButton(
                    text: "Log In",
                    onPressed: () async {
                      // Navigate to splash screen immediately
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const splashScreen1()), // <-- your animated splash
                      );

                      // Run login in background
                      bool success = await loginSignUp.logIn(
                        context,
                        _usernameController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (success) {
                        // Go to home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => homeScreen()),
                        );
                      } else {
                        // Remove splash and go back to login
                        Navigator.pop(context);
                        setState(() {
                          _showNotice = true;
                        });
                      }
                    },
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    backgroundColor: const Color(0xFFC67C4E),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                  SizedBox(height: 22,),
                  CustomElevatedButton(
                      text: "Login with Google",
                      onPressed: () {},
                      width: double.infinity,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.06,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16,
                      borderColor: Colors.white
                  ),
                  SizedBox(height: 84,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InterTextWidget(
                        text: "Already have account?",
                        color: Colors.white,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(width: 6), // Small space between the two texts
                      CustomTextButton(
                        text: 'Sign Up',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: Color(0xFFC67C4E),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => signUpScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.10)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}