import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FilterForm extends StatefulWidget {
  final Function(String, String, String, String, String) onApplyFilters;

  FilterForm({required this.onApplyFilters});

  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  String? _selectedState;
  String? _selectedCity;
  String? _selectedJobCategory;
  String? _selectedSubJobCategory;
  String? _selectedExperience;

  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, dynamic>> _jobCategories = [];
  List<Map<String, dynamic>> _subJobCategories = [];
  List<Map<String, dynamic>> _experience = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _fetchJobCategories();
    _fetchExperience();
    // Fetch states when the widget initializes
  }

  Future<void> _fetchStates() async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_candidate_regions.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // print(response.body);
      setState(() {
        _states = data.map((item) {
          return {
            'id': item['id'],
            'name': item['state'],
          };
        }).toList();
      });
    } else {
      // Handle error
      print('Failed to load states');
    }
  }

  Future<void> _fetchCities(String stateId) async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_candidate_cities.php?state_id=$stateId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _cities = data.map((item) {
          return {
            'id': item['id'],
            'name': item['name'],
          };
        }).toList();
      });
    } else {
      // Handle error
      print('Failed to load cities');
    }
  }

  Future<void> _fetchJobCategories() async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_job_categories.php'));
    //print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _jobCategories = data.map((item) {
          return {
            'id': item['id'],
            'name': item['job_category'], // Adjust key as per API response
          };
        }).toList();
      });
    } else {
      print('Failed to load job categories');
    }
  }

  Future<void> _fetchSubJobCategories(String jobCategoryId) async {
    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/get_sub_job_categories.php?job_category_id=$jobCategoryId'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _subJobCategories = data.map((item) {
          return {
            'id': item['id'],
            'name': item['name'], // Adjust key as per API response
          };
        }).toList();
      });
    } else {
      print('Failed to load sub-job categories');
    }
  }

  Future<void> _fetchExperience() async {
    final response = await http.get(
        Uri.parse('https://www.jijethiopia.com/mobileapp/get_experience.php'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // print(response.body);
      setState(() {
        _experience = data.map((item) {
          return {
            'name': item['experience'],
          };
        }).toList();
      });
    } else {
      // Handle error
      print('Failed to load Experience');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildDropdown(
            'Region',
            _selectedState,
            _states,
            (value) {
              setState(() {
                _selectedState = value;
                _fetchCities(value!); // Fetch cities based on selected state
                _selectedCity = null; // Reset selected city
                _applyFilters();
              });
            },
          ),
          SizedBox(width: 5),
          _buildDropdown(
            'City',
            _selectedCity,
            _cities,
            (value) {
              setState(() {
                _selectedCity = value;
                _applyFilters();
              });
            },
          ),
          SizedBox(width: 5),
          _buildDropdown(
            'Major Job Category',
            _selectedJobCategory,
            _jobCategories,
            (value) {
              setState(() {
                _selectedJobCategory = value;
                _fetchSubJobCategories(
                    value!); // Fetch cities based on selected state
                _selectedSubJobCategory = null;
                _applyFilters();
              });
            },
          ),
          SizedBox(width: 5),
          _buildDropdown(
            'Sub Job Category',
            _selectedSubJobCategory,
            _subJobCategories,
            (value) {
              setState(() {
                _selectedSubJobCategory = value;
                _applyFilters();
              });
            },
          ),
          SizedBox(width: 5),
          _buildDropdown(
            'Experience',
            _selectedExperience,
            _experience,
            (value) {
              setState(() {
                _selectedExperience = value;
                _applyFilters();
              });
            },
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    final selectedStateName = _states.firstWhere(
        (state) => state['id'] == _selectedState,
        orElse: () => {})['name'];

    final selectedCityName = _cities.firstWhere(
        (city) => city['id'] == _selectedCity,
        orElse: () => {})['name'];

    final selectedJobCategoryName = _jobCategories.firstWhere(
        (job) => job['id'] == _selectedJobCategory,
        orElse: () => {})['name'];

    final selectedSubJobCategoryName = _subJobCategories.firstWhere(
        (subJob) => subJob['id'] == _selectedSubJobCategory,
        orElse: () => {})['name'];

    final selectedExperienceName = _experience.firstWhere(
        (exp) => exp['name'] == _selectedExperience,
        orElse: () => {})['name'];

    print('Filters applied:');
    print('State: $selectedStateName');
    print('City: $selectedCityName');
    print('Job Category: $selectedJobCategoryName');
    print('Sub Job Category: $selectedSubJobCategoryName');
    print('Experience: $selectedExperienceName');

    widget.onApplyFilters(
      selectedStateName ?? '',
      selectedCityName ?? '',
      selectedJobCategoryName ?? '',
      selectedSubJobCategoryName ?? '',
      selectedExperienceName ?? '',
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<Map<String, dynamic>> options,
    ValueChanged<String?> onChanged,
  ) {
    // Prepend "All" as a default option
    final dropdownOptions = [
      {'id': 'all', 'name': 'All'},
      ...options,
    ];

    return DropdownButton<String>(
      hint: Text(label),
      value: selectedValue,
      onChanged: onChanged,
      items: dropdownOptions.map((option) {
        return DropdownMenuItem<String>(
          value: option['id'].toString(),
          child: Text(option['name']),
        );
      }).toList(),
      underline: SizedBox(),
    );
  }
}
