import 'package:flutter/material.dart';
import 'signup.dart';
import 'signupemployee.dart';
import 'signupagent.dart';
import 'forget.dart';
import 'welcome.dart'; // Import the welcome page
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for JSON decoding
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    var url = "https://www.jijethiopia.com/mobileapp/fluterlogin.php";
    try {
      var response = await http.post(Uri.parse(url), body: {
        "username": _usernameController.text,
        "password": _passwordController.text,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data["status"] == "Success") {
          // Store values in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('id_user', data['id_user'] ?? '');
          await prefs.setString('id_company', data['id_company'] ?? '');
          await prefs.setString('id_agent', data['id_agent'] ?? '');
          await prefs.setString('uname', data['uname'] ?? '');
          await prefs.setString('role', data['role'] ?? '');
          print(data['id_user']);
          print(data['id_company']);
          print(data['id_company']);
          print(data['uname']);
          print(data['role']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected response from the server.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Just In Job'),
        leading: null,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(Icons.account_circle, color: Color(0xffe04848)),
              hint: Text('Signup'),
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'Candidate',
                  child: Text('Candidate Registration'),
                ),
                DropdownMenuItem<String>(
                  value: 'Employee',
                  child: Text('Employer Registration'),
                ),
                DropdownMenuItem<String>(
                  value: 'Agent',
                  child: Text('Agent Registration'),
                ),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  switch (value) {
                    case 'Candidate':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                      break;
                    case 'Employee':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupEmployeePage()),
                      );
                      break;
                    case 'Agent':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupAgentPage()),
                      );
                      break;
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Logo at the top
            Image.asset(
              'assets/images/justinjob1.jpg',
              height: 100, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 24),
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPage()),
                    );
                  },
                  child: Text('Forgot Password?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> getSessionValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? idUser = prefs.getString('id_user') ?? '';
  String? idCompany = prefs.getString('id_company') ?? '';
  String? idAgent = prefs.getString('id_agent') ?? '';

  // Use these values as needed
}
