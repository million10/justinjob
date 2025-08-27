import 'package:flutter/material.dart';
import 'package:justinjob/MyProfileCompany.dart';
import 'package:justinjob/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:justinjob/candidatesListScreen.dart';
import 'package:justinjob/candidatesShortListScreen.dart';
import 'package:justinjob/screens/landing_page.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'User';
  String _role = '0'; // Default value

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('uname') ?? 'User';
      _role =
          prefs.getString('role') ?? 'User'; // Fetch user name from preferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUST IN JOB'),
        leading: null,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome $_userName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            if (_role == '1')
              ListTile(
                title: Text('My Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()),
                  );
                },
              ),
            if (_role == '2')
              ListTile(
                title: Text('My Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()),
                  );
                },
              ),
            if (_role == '1')
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Search Candidates'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CandidatesListScreen()),
                  );
                },
              ),
            if (_role == '1')
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Short Listed Candidates'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CandidatesShortListScreen()),
                  );
                },
              ),
            if (_role == '2')
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Employers'),
              ),
            if (_role == '2')
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('MailBox'),
              ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue[100],
              child: Text(
                'In this dashboard you are able to Search Verified and Rated Candidates, Connect Directly to Candidates, Change your account settings, Get Your Procurement Process on your fingertips. Got a question? Do not hesitate to drop us a mail.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.yellow[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.group, color: Colors.red, size: 50),
                          SizedBox(height: 10),
                          Text(
                            'VERIFIED CANDIDATES',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '101',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Card(
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.assignment, color: Colors.green, size: 50),
                          SizedBox(height: 10),
                          Text(
                            'APPLICATION FOR JOBS',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
