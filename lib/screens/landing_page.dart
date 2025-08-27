import 'package:flutter/material.dart';
import 'package:justinjob/screens/job_listing_screen.dart'; // Import the LoginPage
import 'drawer.dart';
import 'package:justinjob/models/latest_jobs_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Justin Job'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(), // Add the Drawer here
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Find Your Dream Job Today!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobListingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Partners Section
            // Latest Jobs Section
            SectionHeader(title: 'Latest Jobs'),
            const SizedBox(height: 8),
            const LatestJobsSection(),
            const SizedBox(height: 24),
            // Candidates Section
            SectionHeader(title: 'Candidates'),
            const SizedBox(height: 8),
            const CandidatesSection(),
            const SizedBox(height: 24),
            // Companies Section
            SectionHeader(title: 'Companies'),
            const SizedBox(height: 8),
            const CompaniesSection(),
            const SizedBox(height: 24),
            // Statistics Section
            SectionHeader(title: 'Our Statistics'),
            const SizedBox(height: 8),
            const StatisticsSection(),
            const SizedBox(height: 24),

            // Contact Us Section
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

// Add other sections (PartnersSection, LatestJobsSection, etc.) here..

/*class LatestJobsSection extends StatelessWidget {
  const LatestJobsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4, // Replace with actual data from your database
        (index) => const JobCard(
          logo: 'assets/images/justinjob1.jpg', // Replace with actual logo path
          jobTitle: 'Job Title',
          companyName: 'Company Name',
          qualification: 'Qualification',
          experience: '2 Years',
          salary: 'ETB 10,000',
          postedDate: 'Posted: 2023-10-01',
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String logo;
  final String jobTitle;
  final String companyName;
  final String qualification;
  final String experience;
  final String salary;
  final String postedDate;

  const JobCard({
    required this.logo,
    required this.jobTitle,
    required this.companyName,
    required this.qualification,
    required this.experience,
    required this.salary,
    required this.postedDate,
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
                Image.asset(logo, height: 50),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jobTitle,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                          '$companyName | $qualification | Experience: $experience'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(postedDate),
                Text('Salary: $salary'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/

class CandidatesSection extends StatelessWidget {
  const CandidatesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Your Dream Job Awaits with Justin PLC.'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              CandidateOptionCard(
                image: AssetImage('assets/images/justinjob1.jpg'),
                title: 'Sign Up Now',
                route: 'register-candidates',
              ),
              CandidateOptionCard(
                image: AssetImage('assets/images/justinjob1.jpg'),
                title: 'Connect with Employers',
                route: 'login-candidates',
              ),
              CandidateOptionCard(
                image: AssetImage('assets/images/justinjob1.jpg'),
                title: 'Develop Your Career',
                route: 'login-candidates',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionHeader(title: 'Top Rated Candidates'),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            5, // Replace with actual data from your database
            (index) => const CandidateCard(
              name: 'Candidate Name',
              rating: 4,
              profileImage: 'assets/images/avatar_male.jpg',
            ),
          ),
        ),
      ],
    );
  }
}

class CandidateOptionCard extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String route;

  const CandidateOptionCard({
    required this.image,
    required this.title,
    required this.route,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to the specified route
        },
        child: Column(
          children: [
            Image(
              image: image, // Use the ImageProvider here
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class CandidateCard extends StatelessWidget {
  final String name;
  final int rating;
  final String profileImage;

  const CandidateCard({
    required this.name,
    required this.rating,
    required this.profileImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < rating ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompaniesSection extends StatelessWidget {
  const CompaniesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Connect with Top Candidates Instantly with Justin PLC.'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              CompanyOptionCard(
                image: 'assets/images/justinjob1.jpg',
                title: 'Sign Up Now',
                route: 'register-company',
              ),
              CompanyOptionCard(
                image: 'assets/images/justinjob1.jpg',
                title: 'Search Candidates',
                route: 'login-company',
              ),
              CompanyOptionCard(
                image: 'assets/images/justinjob1.jpg',
                title: 'Connect with Candidates',
                route: 'login-company',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CompanyOptionCard extends StatelessWidget {
  final String image;
  final String title;
  final String route;

  const CompanyOptionCard({
    required this.image,
    required this.title,
    required this.route,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to the specified route
        },
        child: Column(
          children: [
            Image.asset(image, height: 100),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceEvenly,
      children: const [
        StatisticCard(label: 'Registered Employers', value: 55),
        StatisticCard(label: 'Registered Agents', value: 5),
        StatisticCard(label: 'Registered Candidates', value: 878),
        StatisticCard(label: 'Verified Candidates', value: 720),
      ],
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String label;
  final int value;

  const StatisticCard({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class IconTextCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconTextCard({required this.icon, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
