import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Retrieve id_company from SharedPreferences
Future<String?> getCompanyId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('id_company');
}

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? companyData;
  List<dynamic>? comments;
  double? averageRating;
  int? ratingCount;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchCompanyData();
  }

  Future<void> fetchCompanyData() async {
    await printStoredPreferences();
    try {
      final String? idCompany = await getCompanyId();

      if (idCompany == null) {
        // Handle the case where idCompany is not set
        print('No company ID found.');
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://www.jijethiopia.com/mobileapp/getCompanyData.php?id_company=$idCompany'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] != null) {
          // Handle the error here
          print('API Error: ${data['error']}');
          // Possibly redirect to login or show an error message
        } else {
          setState(() {
            companyData = data['company'];
            comments = data['comments'];
            averageRating = data['averageRating'];
            ratingCount = data['ratingCount'];
          });
        }
      } else {
        throw Exception('Failed to load company data');
      }
    } catch (e) {
      print('Error fetching company data: $e');
      // Handle exception, show error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Info'),
            Tab(text: 'Update'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildInfoTab(),
          buildUpdateTab(),
        ],
      ),
    );
  }

  Widget buildInfoTab() {
    return companyData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(companyData!['logo'] ??
                        'https://www.jijethiopia.com/img/default-user.png'),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  companyData!['name'] ?? 'No name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Email: ${companyData?['email'] ?? 'N/A'}'),
                Text('Region: ${companyData?['region'] ?? 'N/A'}'),
                Text('City: ${companyData?['city'] ?? 'N/A'}'),
                Text('Phone: ${companyData?['contactno'] ?? 'N/A'}'),
                Text('About Me: ${companyData?['aboutme'] ?? 'N/A'}'),
                SizedBox(height: 16),
                Text('Average Rating: ${averageRating ?? 'N/A'} / 5'),
                RatingBar.builder(
                  initialRating: averageRating ?? 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Text('(${ratingCount ?? 0} Ratings)'),
                SizedBox(height: 16),
                Text('Comments:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                comments == null || comments!.isEmpty
                    ? Text('No comments yet.')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                comments![index]['comment'] ?? 'No comment'),
                            subtitle: Text(
                                'By ${comments![index]['user_name'] ?? 'Unknown'} on ${comments![index]['created_at'] ?? 'Unknown'}'),
                          );
                        },
                      ),
              ],
            ),
          );
  }

  Widget buildUpdateTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Company Name'),
              initialValue: companyData!['name'],
              // Add other form fields similarly
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Submit the form
              },
              child: Text('Update Company Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> printStoredPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? idUser = prefs.getString('id_user');
  String? idCompany = prefs.getString('id_company');
  String? idAgent = prefs.getString('id_agent');

  print('Stored Preferences:');
  print('id_user: $idUser');
  print('id_company: $idCompany');
  print('id_agent: $idAgent');
}
/*import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Info'),
            Tab(text: 'Update'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InfoTab(),
          UpdateTab(),
        ],
      ),
    );
  }
}

class InfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace the following with actual data fetching and display logic
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/company_logo.png'), // Replace with actual image
                ),
                SizedBox(height: 10),
                Text(
                  'TechNatET ICT Solutions Company',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Average Rating: 0 / 5', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text('Email: technatet@gmail.com', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('City: Nefas Silk Lafto', style: TextStyle(fontSize: 18)),
          // Add more fields as needed
        ],
      ),
    );
  }
}

class UpdateTab extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: _websiteController,
              decoration: InputDecoration(labelText: 'Website'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextField(
              controller: _aboutController,
              decoration: InputDecoration(labelText: 'About Me'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Text('Change Company Picture', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add image picker logic here
              },
              child: Text('Browse...'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add profile update logic here
                },
                child: Text('Update Company Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
