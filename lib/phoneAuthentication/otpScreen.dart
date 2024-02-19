import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OtpVerificationScreen({required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Enter the OTP sent to ${widget.phoneNumber}'),
              SizedBox(height: 20.0),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Call the function to verify OTP
                  _verifyOtp(context);
                },
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to verify OTP
  void _verifyOtp(BuildContext context) {
    String otp = _otpController.text.trim();

    // Validate OTP
    if (otp.isEmpty) {
      _showSnackBar(context, 'Please enter OTP');
      return;
    }

    // Use firebase_phone_auth_handler to verify OTP
    // Add your verification logic here
    // For example:
    // bool isVerified = await FirebaseAuthHandler.instance.verifyOtp(otp);

    // if (isVerified) {
    //   // OTP verification successful
    //   // Navigate to home screen or any other screen as needed
    //   Navigator.pushReplacementNamed(context, '/home');
    // } else {
    //   _showSnackBar(context, 'Invalid OTP. Please try again.');
    // }
  }

  // Function to show a snackbar with a given message
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _otpController.dispose();
    super.dispose();
  }
}
