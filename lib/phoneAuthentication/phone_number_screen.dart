import 'package:flutter/material.dart';
import 'package:tracker/phoneAuthentication/otpScreen.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Call the function to authenticate the phone number
                  _authenticatePhoneNumber(context);
                  // Navigator.of(context)
                  // .push(MaterialPageRoute(builder: (context) => OtpVerificationScreen(phoneNumber: _phoneNumberController,)));
                },
                child: Text('Verify Phone Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to authenticate the phone number
  void _authenticatePhoneNumber(BuildContext context) async {
    String phoneNumber = _phoneNumberController.text.trim();

    // Validate phone number
    if (phoneNumber.isEmpty) {
      _showSnackBar(context, 'Please enter a valid phone number');
      return;
    }

    // Use firebase_phone_auth_handler to send OTP
    // Add your authentication logic here
    // For example:
    // await FirebaseAuthHandler.instance.verifyPhoneNumber(phoneNumber);

    // Once OTP is sent, navigate to OTP verification screen
    Navigator.pushNamed(context, '/otp_verification', arguments: phoneNumber);
  }

  // Function to show a snackbar with a given message
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _phoneNumberController.dispose();
    super.dispose();
  }
}
