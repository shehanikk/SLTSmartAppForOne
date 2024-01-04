import 'package:finalsmartterraapp/Home.dart';
import 'package:finalsmartterraapp/login.dart';
import 'package:finalsmartterraapp/phone.dart';
import 'package:finalsmartterraapp/utils/color_utils.dart';
import 'package:flutter/material.dart';


class OtpEmailBtnPage extends StatefulWidget {
  const OtpEmailBtnPage({super.key});

  @override
  State<OtpEmailBtnPage> createState() => _OtpEmailBtnPageState();
}

class _OtpEmailBtnPageState extends State<OtpEmailBtnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff073d07),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'ECOGARDEN',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        toolbarHeight: 50,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("F9FFFA"),
              hexStringToColor("3A14A460"),
              hexStringToColor("F9FFFA")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/otp.png', height: 380, width: 300,),
              Container(
                width: 280,
                height: 53,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => SignInScreen(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(7, 61, 7, 1)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: Text('Email Verification'),
                ),
              ),
              SizedBox(height: 19),
              Container(
                width: 280,
                height: 53,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => MyPhone(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff073d07)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: Text('Phone Verification'),
                ),
              ),
              SizedBox(height: 19),

              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => GreenHouseHome(),
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                      TextDecoration.underline, // Underline the text
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}