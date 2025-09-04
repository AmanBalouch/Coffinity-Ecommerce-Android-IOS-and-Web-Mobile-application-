import 'package:coffeemobileapplicationandroid/UX/Providers/authProvider.dart';
import 'package:coffeemobileapplicationandroid/screens/homeScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:coffeemobileapplicationandroid/UX/loginSignUp.dart';
import 'package:provider/provider.dart';

import '../helpers/widgets.dart';

class signUpScreen extends StatefulWidget{
  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  TextEditingController _usernameController=TextEditingController();

  TextEditingController _emailController=TextEditingController();

  TextEditingController _passwordController=TextEditingController();
  bool _showNotice=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // This disables auto-resizing
      // backgroundColor:Color(0xFF230C02),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    child: InterTextWidget(text: "Hi,\nWelcome!", color: Colors.white, size: 34, weight: FontWeight.w700)),
                SizedBox(height: 42),
                LogoTextField(
                  icon: Icons.person,
                  hintText: "Enter ur name",
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  backgroundColor: Color(0xFF3A2921),
                  borderRadius: 16,
                  controller: _usernameController,
                ),
                SizedBox(height: 25,),
                LogoTextField(
                  icon: Icons.email_outlined,
                  hintText: "Email address",
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  backgroundColor: Color(0xFF3A2921),
                  borderRadius: 16,
                  controller: _emailController,
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
                SizedBox(height: 50,),
                CustomElevatedButton(
                    text: "Sign Up",
                    onPressed: () async {
                      if(await loginSignUp.signUp(context,_emailController.text.toString(),_passwordController.text.toString(),_usernameController.text.toString()))
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homeScreen()));
                      else {
                        setState(() {
                          _showNotice=true;
                        });
                      }
                    },
                    width: double.infinity,
                    height:MediaQuery.of(context).size.height * 0.06,
                    backgroundColor: Color(0xFFC67C4E),
                    textColor: Colors.white,
                    fontSize: 16),
                SizedBox(height: 22,),
                CustomElevatedButton(
                    text: "SignUp with Google",
                    onPressed: (){},
                    width: double.infinity,
                    height:MediaQuery.of(context).size.height * 0.06,
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
                    CustomTextButton(
                      text: 'Log in',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: Color(0xFFC67C4E),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loginScreen()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.10)
              ],
            ),
          ],
        ),
      ),
    );
  }
}