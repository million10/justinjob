import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestJobsSection extends StatefulWidget {
  const LatestJobsSection({Key? key}) : super(key: key);

  @override
  _LatestJobsSectionState createState() => _LatestJobsSectionState();
}

class _LatestJobsSectionState extends State<LatestJobsSection> {
  List<dynamic> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchLatestJobs();
  }

  Future<void> fetchLatestJobs() async {
    final response = await http.get(
      Uri.parse(
          'https://www.jijethiopia.com/mobileapp/fetch_latest_jobs.php'), // Replace with your server address
    );

    if (response.statusCode == 200) {
      setState(() {
        jobs = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (jobs.isEmpty)
          const Center(child: Text('No Jobs Found'))
        else
          ...jobs.map((job) {
            return JobCard(
              jobTitle: job['jobtitle'],
              companyName: job['company_name'],
              qualification: job['qualification'],
              experience: job['experience'],
              postedDate: job['createdat'],
              salary: job['maximumsalary'],
              logo: job['logo'],
            );
          }).toList(),
      ],
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String qualification;
  final String experience;
  final String postedDate;
  final String salary;
  final String logo;

  const JobCard({
    required this.jobTitle,
    required this.companyName,
    required this.qualification,
    required this.experience,
    required this.postedDate,
    required this.salary,
    required this.logo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  'https://www.jijethiopia.com/uploads/logo/$logo', // Replace with your server address
                  height: 50,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$companyName | $qualification | Experience: $experience Years',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posted: $postedDate'),
                Text('Salary: $salary'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
