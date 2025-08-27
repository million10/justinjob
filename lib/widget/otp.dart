import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:justinjob/signupemployee.dart';

class OTPPage extends StatefulWidget {
  final String userId; // Pass user ID or any identifier to link OTP to a user

  OTPPage({required this.userId});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://www.jijethiopia.com/mobileapp/verify_otp.php'),
      body: {
        'user_id': widget.userId,
        'otp': _otpController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('OTP verification successful!'),
          backgroundColor: Colors.green,
        ));
        // Navigate to the next page, e.g., login page or dashboard
        Navigator.pushReplacementNamed(
            context, '/nextPage'); // Update with your route
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _verifyOTP,
                      child: Text('Verify OTP'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
