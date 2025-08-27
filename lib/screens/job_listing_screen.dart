import 'package:flutter/material.dart';

class JobListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Welcome back,\nDavid Robert Wilson',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Let's get you hired for the job you deserve!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Chip(label: Text('All')),
                SizedBox(width: 10),
                Chip(label: Text('Marketing')),
                SizedBox(width: 10),
                Chip(label: Text('Design')),
                SizedBox(width: 10),
                Chip(label: Text('Administration')),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobDetailScreen()),
                    );
                  },
                  child: JobCard(
                    title: 'Accountant',
                    company: 'Google',
                    location: 'California, US',
                    salary: '\$235/month',
                    isUrgent: true,
                  ),
                ),
                JobCard(
                  title: 'Marketing',
                  company: 'Shopify',
                  location: 'California, US',
                  salary: '\$410/month',
                  isUrgent: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final bool isUrgent;

  JobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('$company • $location'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(salary, style: TextStyle(color: Colors.green)),
                if (isUrgent)
                  Chip(
                    label:
                        Text('URGENT', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JobDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accountant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Google • California, US'),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text('Fulltime')),
                SizedBox(width: 10),
                Chip(label: Text('Remote')),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'About this role',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'An Accountant plays a key role in managing and overseeing the financial activities of an organization. This includes preparing financial reports, maintaining accurate financial records, and conducting audits.',
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Apply this job'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
