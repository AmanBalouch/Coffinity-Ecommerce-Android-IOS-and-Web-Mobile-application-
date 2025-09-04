import 'package:coffeemobileapplicationandroid/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UX/Providers/authProvider.dart';
import '../UX/loginSignUp.dart';
import '../helpers/widgets.dart';

class forgotPasswordScreen extends StatefulWidget {
  @override
  State<forgotPasswordScreen> createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  bool _showNotice = false;

  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // This disables auto-resizing
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showNotice)
              NoticeBox(
                message: context.watch<authProvider>().getMessage(),
                bgColor: Colors.redAccent,
              ),
            SizedBox(height: 42),
            LogoTextField(
              icon: Icons.email_outlined,
              hintText: "Enter your email address",
              textColor: Colors.white,
              iconColor: Colors.white,
              backgroundColor: Color(0xFF3A2921),
              borderRadius: 16,
              controller: _emailController,
            ),
            SizedBox(height: 20),
            CustomElevatedButton(
              text: "Reset Password",
              onPressed: () async {
                if (await loginSignUp.forgotPassword(
                  context,
                  _emailController.text.toString().trim(),
                )) {
                  setState(() {
                    _showNotice = true;
                  });
                }
                else {
                  setState(() {
                    _showNotice = true;
                  });
                }
              },
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              backgroundColor: Color(0xFFC67C4E),
              textColor: Colors.white,
              fontSize: 16,
            ),
            SizedBox(height: 20,),
            CustomElevatedButton(
              text: "Back to login screen",
              onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => loginScreen()),
                  );
              },
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              backgroundColor: Color(0xFFC67C4E),
              textColor: Colors.white,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
