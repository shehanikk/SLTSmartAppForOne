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

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("FFFFFF"),
              hexStringToColor("FFFFFF"),
              hexStringToColor("084218")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/singinImg.png',  width: 300,),
              SizedBox(height: 30,),
              Text('Welcome To EcoGarden', style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 30,),
              Container(
                width: 300,
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
                            90), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: Text('Email Verification', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ),
              SizedBox(height: 19),
              Container(
                width: 300,
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
                            90), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: Text('Phone Verification', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ),

              SizedBox(height: 19),
              Container(
                width: 300,
                height: 53,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GreenHouseHome(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff073d07)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            90), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: Text('Skip', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}