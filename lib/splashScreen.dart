import 'package:finalsmartterraapp/login.dart';
import 'package:finalsmartterraapp/otpemailbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = VideoPlayerController.asset('images/splashvid.mp4');

    try {
      _controller.initialize().then((_) {
        // Ensure the first frame is shown
        if (mounted) { // Check if the widget is still active
          setState(() {});
          _controller.play();
        }
      });
    } catch (error) {
      // Handle the error here (e.g., show an error message, log the error, or navigate to an error screen).
      print('Error initializing video: $error');
    }

    // Schedule navigation only if the widget is still mounted.
    if (mounted) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OtpEmailBtnPage(),
          ),
        );
      });
    }
  }


  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.asset(
                    'images/sltnew.png',
                    height: 60, // Adjust the height as needed
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: 0.7, // Adjust the scale factor as needed
                  child: Image.asset('images/newLogo.png'), // Replace with your logo asset
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
