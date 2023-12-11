import 'package:finalsmartterraapp/reusable_widgets/reusable_widget.dart';
import 'package:finalsmartterraapp/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          "RESET PASSWORD",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("013212"),
                hexStringToColor("3AA467"),
                hexStringToColor("F9FFFA"),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Forget your password ? \n Just enter your email, We'll send you \n a link to reset your password.", style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    reusableTextField("Enter Your Email", Icons.email, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "RESET PASSWORD", () {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _emailTextController.text)
                          .then((value) => Navigator.of(context).pop());
                    })
                  ],
                ),
              ))),
    );
  }
}