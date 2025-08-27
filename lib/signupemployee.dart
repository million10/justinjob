import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

class SignupEmployeePage extends StatefulWidget {
  @override
  _SignupEmployeePageState createState() => _SignupEmployeePageState();
}

class _SignupEmployeePageState extends State<SignupEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  bool _agreedToLicense = false;
  List<dynamic> _countries = [];
  List<dynamic> _states = [];
  List<dynamic> _cities = [];

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _webSiteController = TextEditingController();

  File? _profilePicture;

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
    }
  }

  Future<void> _fetchStates(String countryId) async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_states.php?country_id=$countryId'));
    if (response.statusCode == 200) {
      setState(() {
        _states = json.decode(response.body);
      });
    }
  }

  Future<void> _fetchCities(String stateId) async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_cities.php?state_id=$stateId'));
    if (response.statusCode == 200) {
      setState(() {
        _cities = json.decode(response.body);
      });
    }
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  Future<void> _completeRegistration() async {
    final response = await http.post(
      Uri.parse('https://www.jijethiopia.com/mobileapp/register_employer.php'),
      body: {
        'name': _fullNameController.text,
        'companyname': _usernameController.text,
        'website': _webSiteController.text,
        'email': _emailController.text,
        'contactno': _phoneController.text,
        'password': _passwordController.text,
        'aboutme': _aboutController.text,
        'country': _selectedCountry ?? '',
        'state': _selectedState ?? '',
        'city': _selectedCity ?? '',
        'image': _profilePicture != null
            ? base64Encode(_profilePicture!.readAsBytesSync())
            : '',
        'terms': _agreedToLicense ? '1' : '0',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final intStatus = int.tryParse(responseBody['status'].toString()) ?? 500;

      if (intStatus == 202) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Success: ${responseBody['message']}'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['message'] ?? 'Unexpected Error'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up - Employer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Company/Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your full name'
                      : null,
                ),
                // Username Field
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
                  controller: _webSiteController,
                  decoration: InputDecoration(
                    labelText: 'Web Site',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Phone Number Field
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

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // About Field
                TextFormField(
                  controller: _aboutController,
                  decoration: InputDecoration(
                    labelText: 'About You',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please tell us something about yourself';
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
                // Profile Picture Picker
                ElevatedButton(
                  onPressed: _pickProfilePicture,
                  child: Text('Select Profile Picture'),
                ),
                SizedBox(height: 16),

                // Terms and Conditions Checkbox
                CheckboxListTile(
                  title: Text('I agree to the terms and conditions'),
                  value: _agreedToLicense,
                  onChanged: (newValue) {
                    setState(() {
                      _agreedToLicense = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _completeRegistration,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
