import 'package:finalsmartterraapp/Home.dart';
import 'package:finalsmartterraapp/profile.dart';
import 'package:finalsmartterraapp/reusable_widgets/reusable_widget.dart';
import 'package:finalsmartterraapp/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          "SIGN UP",
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
                      height: 20,
                    ),
                    reusableTextField("Enter Username", Icons.person, false,
                        _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email", Icons.email, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "SIGN UP", () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                          .then((value) {
                        print("Created New Account");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => GreenHouseHome()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }),

                    const SizedBox(
                      height: 20,
                    ),

                    logoWidget("images/signupback.png"),
                    const SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ))),
    );
  }
}