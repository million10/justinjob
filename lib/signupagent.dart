import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'login.dart';

class SignupAgentPage extends StatefulWidget {
  @override
  _SignupAgentPageState createState() => _SignupAgentPageState();
}

class _SignupAgentPageState extends State<SignupAgentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSex;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  bool _agreedToLicense = false;
  List<dynamic> _countries = [];
  List<dynamic> _states = [];
  List<dynamic> _cities = [];

  // Form field controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final response = await http.get(
        Uri.parse('https://www.jijethiopia.com/mobileapp/get_countries.php'));
    if (response.statusCode == 200) {
      setState(() {
        _countries = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> _fetchStates(String countryId) async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_states.php?country_id=$countryId'));
    if (response.statusCode == 200) {
      setState(() {
        _states = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> _fetchCities(String stateId) async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_cities.php?state_id=$stateId'));
    if (response.statusCode == 200) {
      setState(() {
        _cities = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('https://www.jijethiopia.com/mobileapp/register_agent.php'),
      body: {
        'contactno': phoneNumber,
        'action': 'sendOtp',
        'username': _usernameController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final status = int.tryParse(responseBody['status'].toString()) ?? 500;

      if (status == 200) {
        _showOtpDialog(context, phoneNumber);
      } else if (status == 403) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Username exists.'),
          backgroundColor: Colors.red,
        ));
      } else if (status == 405) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('OTP exists, use the previously sent OTP.'),
          backgroundColor: Colors.red,
        ));
        _showOtpDialog(context, phoneNumber);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('OTP sending failed: ${responseBody['message']}'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred while sending OTP.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showOtpDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('An OTP has been sent to $phoneNumber'),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Verify & Register'),
              onPressed: () async {
                final otp = _otpController.text;

                if (otp.isNotEmpty) {
                  await _verifyOtp(otp, phoneNumber, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the OTP')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyOtp(
      String otp, String phoneNumber, BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://www.jijethiopia.com/mobileapp/register_agent.php'),
      body: {
        'contactno': phoneNumber,
        'otp': otp,
        'action': 'register',
        'name': _fullNameController.text,
        'username': _usernameController.text,
        'email': _usernameController.text,
        'password': _passwordController.text,
        'country': _selectedCountry!,
        'state': _selectedState!,
        'city': _selectedCity!,
        'terms': _agreedToLicense ? '1' : '0',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final status = responseBody['status'];
      final intStatus =
          (status is String) ? int.tryParse(status) : status as int;

      if (intStatus == 202) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Success: ${responseBody['message']}'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (intStatus == 403) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Username exists.'),
          backgroundColor: Colors.red,
        ));
      } else if (intStatus == 203) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Problem in database.'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unexpected error.'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while verifying OTP.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up as Agent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSex,
                  decoration: InputDecoration(
                    labelText: 'Sex',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female'].map((sex) {
                    return DropdownMenuItem(
                      value: sex,
                      child: Text(sex),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSex = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your sex';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Country Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      value: country['id'].toString(),
                      child: Text(country['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                      _selectedState = null;
                      _selectedCity = null;
                      _fetchStates(value!);
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // State Dropdown
                if (_selectedCountry != null)
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                    items: _states.map((state) {
                      return DropdownMenuItem(
                        value: state['id'].toString(),
                        child: Text(state['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                        _selectedCity = null;
                        _fetchCities(value!);
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a state';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 16),

                // City Dropdown
                if (_selectedState != null)
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    items: _cities.map((city) {
                      return DropdownMenuItem(
                        value: city['id'].toString(),
                        child: Text(city['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a city';
                      }
                      return null;
                    },
                  ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Profile Image'),
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('I agree to the license terms'),
                  value: _agreedToLicense,
                  onChanged: (value) {
                    setState(() {
                      _agreedToLicense = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _agreedToLicense) {
                      _sendOtp(_phoneController.text);
                    } else if (!_agreedToLicense) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please agree to the license terms'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
