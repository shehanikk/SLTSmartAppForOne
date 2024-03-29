import 'package:finalsmartterraapp/Home.dart';
import 'package:finalsmartterraapp/otpemailbtn.dart';
import 'package:finalsmartterraapp/phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MyOtp extends StatefulWidget {
  const MyOtp({super.key});

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );


    var code="";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OtpEmailBtnPage()), // Replace EmailScreen with the actual name of your widget
            );
          },
        ),
      ),

      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/sihj.png', height: 250, width: 250,),
              SizedBox(height: 25,),


              Text('Phone Verification', style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              Text('We need to register your phone number',style: TextStyle(
                fontSize: 16,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30,),

              Pinput(

                length: 6,

                showCursor: true,
                onChanged: (value) {
                  code=value;
                },

              ),

              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child:   ElevatedButton(
                  onPressed: () async{
                    try{
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: MyPhone.Verify, smsCode: code);

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => GreenHouseHome(),
                        ),
                      );

                    }
                    catch(e){
                      print("wrong otp");
                    }

                  },
                  child: Text('Verify phone number', style: TextStyle(color: Colors.white, fontSize: 16),), style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),),
              ),

              Row(
                children: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => MyPhone(),
                      ),
                    );
                  }, child: Text ('Change phone number ?', style: TextStyle(color: Colors.black),))
                ],
              )





            ],
          ),
        ),
      ),
    );
  }
}