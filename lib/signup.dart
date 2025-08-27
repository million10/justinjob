import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart'; // Use this package

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSex;
  String? _selectedJobType;
  List<String> _jobCategories = [];
  List<String> _subJobCategories = [];
  List<String> _selectedJobCategories = [];
  List<String> _selectedSubJobCategories = [];
  List<String> _selectedLanguages = [];
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  bool _agreedToLicense = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDateOfBirth;
  String? _selectedEducationLevel;
  String? _selectedWorkExperience;
  final _addressController = TextEditingController();
  final _skillsController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _placeofbirhtController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<dynamic> _countries = [];
  List<dynamic> _states = [];
  List<dynamic> _cities = [];
  final List<String> _languages = [
    'English',
    'Amharic',
    'Oromifa',
    'Somali',
    'Afar'
  ];
  final List<String> _educationLevels = [
    'High School',
    'Diploma',
    'Bachelor',
    'Master',
    'PhD'
  ];
  final List<String> _workExperiences = [
    '0-1 Years',
    '1-2 Years',
    '2-3 Years',
    '3-4 Years',
    '4-5 Years',
    'More than 5 Years'
  ];

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

  Future<void> _fetchJobCategories(String jobType) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.jijethiopia.com/mobileapp/job_category.php?job_type=$jobType'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('categories')) {
          setState(() {
            _jobCategories = List<String>.from(data['categories']);
            _subJobCategories =
                []; // Clear sub-job categories when job type changes
          });
        } else {
          throw Exception('No job categories found');
        }
      } else {
        throw Exception('Failed to load job categories');
      }
    } catch (e) {
      print('Error fetching job categories: $e');
    }
  }

  Future<void> _fetchSubJobCategories(List<String> jobCategories) async {
    try {
      final jobCategoriesString = jobCategories.join(',');

      final response = await http.get(Uri.parse(
          'https://www.jijethiopia.com/mobileapp/sub_job_category.php?job_category=$jobCategoriesString'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('sub_categories')) {
          setState(() {
            _subJobCategories = List<String>.from(data['sub_categories']);
            _selectedSubJobCategories = [];
          });
        } else {
          throw Exception('No sub job categories found');
        }
      } else {
        throw Exception('Failed to load sub job categories');
      }
    } catch (e) {
      print('Error fetching sub job categories: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true && _agreedToLicense) {
      final response = await http.post(
        Uri.parse(
            'https://www.jijethiopia.com/mobileapp/candidateregistration.php'),
        body: {
          'full_name': _fullNameController, // Replace with actual data
          'username': _usernameController, // Replace with actual data
          'email': _emailController, // Replace with actual data
          'place_of_birth': _placeofbirhtController, // Replace with actual data
          'phone_number': _phoneController,
          'skill': _skillsController, // Replace with actual data
          'sex': _selectedSex ?? '',
          'job_type': _selectedJobType ?? '',
          'job_categories':
              _selectedJobCategories.join(','), // Combine into a single string
          'sub_job_categories': _selectedSubJobCategories.join(','),
          'languages': _selectedLanguages.join(','),
          'country': _selectedCountry ?? '',
          'state': _selectedState ?? '',
          'city': _selectedCity ?? '',
          'password': _passwordController, // Replace with actual data
          'confirm_password': _passwordController, // Replace with actual data
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    } else if (!_agreedToLicense) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must agree to the license terms')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  'Create Candidate Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'fullname',
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
                    labelText: 'User name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Emali',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _placeofbirhtController,
                  decoration: InputDecoration(
                    labelText: 'Place of Birth',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter place of birth';
                    }
                    return null;
                  },
                ),
                // Other input fields
                SizedBox(height: 16),
                DateTimePicker(
                  label: 'Date of Birth',
                  selectedDate: _selectedDateOfBirth,
                  onDateChanged: (newDate) {
                    setState(() {
                      _selectedDateOfBirth = newDate;
                    });
                  },
                ),

                SizedBox(height: 16),
                // Radio buttons for Job Type selection
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Formal Job'),
                        value: '0',
                        groupValue: _selectedJobType,
                        onChanged: (value) {
                          setState(() {
                            _selectedJobType = value;
                            _fetchJobCategories(_selectedJobType!);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Informal Job'),
                        value: '1',
                        groupValue: _selectedJobType,
                        onChanged: (value) {
                          setState(() {
                            _selectedJobType = value;
                            _fetchJobCategories(_selectedJobType!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_selectedJobType != null) ...[
                  SizedBox(height: 16),
                  // Dropdown for Job Categories
                  DropdownSearch<String>.multiSelection(
                    items: _jobCategories,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Job Categories',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedJobCategories = value;
                        _fetchSubJobCategories(
                            value); // Fetch sub-job categories
                      });
                    },
                    selectedItems: _selectedJobCategories,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select at least one job category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Dropdown for Sub Job Categories
                  DropdownSearch<String>.multiSelection(
                    items: _subJobCategories,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Sub Job Categories',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubJobCategories = value;
                      });
                    },
                    selectedItems: _selectedSubJobCategories,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select at least one sub-job category';
                      }
                      return null;
                    },
                  ),
                ],

                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedEducationLevel,
                  decoration: InputDecoration(
                    labelText: 'Education Level',
                    border: OutlineInputBorder(),
                  ),
                  items: _educationLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEducationLevel = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your education level';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedWorkExperience,
                  decoration: InputDecoration(
                    labelText: 'Work Experience',
                    border: OutlineInputBorder(),
                  ),
                  items: _workExperiences.map((experience) {
                    return DropdownMenuItem(
                      value: experience,
                      child: Text(experience),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedWorkExperience = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your work experience';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownSearch<String>.multiSelection(
                  items: _languages,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Languages Spoken',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguages = value;
                    });
                  },
                  selectedItems: _selectedLanguages,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select at least one language';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _skillsController,
                  decoration: InputDecoration(
                    labelText: 'Skills',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your skills';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
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
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone No',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('I agree to the license terms'),
                  value: _agreedToLicense,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreedToLicense = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateTimePicker({
    Key? key,
    required this.label,
    this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            child: InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  onDateChanged(pickedDate);
                }
              },
              child: Text(
                selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'Select Date',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
