import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'candidate.dart';
import 'widget/StarRating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getCompanyId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('id_company');
}

class CandidateDetailsScreen extends StatefulWidget {
  final Candidate candidate;

  CandidateDetailsScreen({required this.candidate});

  @override
  _CandidateDetailsScreenState createState() => _CandidateDetailsScreenState();
}

class _CandidateDetailsScreenState extends State<CandidateDetailsScreen> {
  bool isShortlisted = false;

  @override
  void initState() {
    super.initState();
    // Check if the candidate is already shortlisted
    isShortlisted =
        widget.candidate.isHired == '3'; // '3' is the code for "Shortlisted"
  }

  Future<bool> updateHiringStatus(String candidateId, String companyId,
      String status, String isHired) async {
    final response = await http.post(
      Uri.parse('https://www.jijethiopia.com/mobileapp/update_shortlist.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_user": candidateId,
        "id_company": companyId,
        "status": status, // Status String (e.g., "Hired", "Short Listed", etc.)
        "is_hired":
            isHired, // Numeric value (1 for hired, 2 for interview, 3 for shortlisted)
      }),
    );

    final data = jsonDecode(response.body);
    return data["status"] == "success";
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = widget.candidate.profilePictureUrl != null
        ? 'https://www.jijethiopia.com/${widget.candidate.profilePictureUrl}'
        : null;
    String defaultAvatar = widget.candidate.gender == 'Female'
        ? 'assets/images/avatar_female.jpg'
        : 'assets/images/avatar_male.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.candidate.name}'),
        backgroundColor: Colors.yellow[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage:
                  profileImageUrl != null && profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : AssetImage(defaultAvatar) as ImageProvider,
              radius: 50,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              widget.candidate.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Average Rating: ${widget.candidate.rating}/5',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            StarRating(rating: widget.candidate.rating),
            SizedBox(height: 8),

            // Show the action buttons based on the candidate's isHired status
            if (widget.candidate.isHired == '1') ...[
              // If candidate is hired
              SizedBox(height: 8),
              Text(
                'Candidate Is Hired Please Rate The Profile',
                style: TextStyle(color: Colors.green),
              ),
            ] else if (widget.candidate.isHired == '2') ...[
              // If candidate is scheduled for an interview
              SizedBox(height: 8),
              Text(
                'On Progress (Scheduled For an Interview)',
                style: TextStyle(color: Colors.orange),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  String? companyId = await getCompanyId();
                  if (companyId != null) {
                    bool success = await updateHiringStatus(
                        widget.candidate.id, companyId, 'Hired', '1');
                    if (success) {
                      setState(() {
                        widget.candidate.isHired = '1';
                      });
                    }
                  }
                },
                child: Text('Mark As Hired'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ] else if (widget.candidate.isHired == '3') ...[
              // If candidate is shortlisted
              ElevatedButton(
                onPressed: () async {
                  String? companyId = await getCompanyId();
                  if (companyId != null) {
                    bool success = await updateHiringStatus(widget.candidate.id,
                        companyId, 'Scheduled For Interview', '2');
                    if (success) {
                      setState(() {
                        widget.candidate.isHired = '2';
                      });
                    }
                  }
                },
                child: Text('Schedule For Interview'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  String? companyId = await getCompanyId();
                  if (companyId != null) {
                    bool success = await updateHiringStatus(
                        widget.candidate.id, companyId, 'Rejected', '0');
                    if (success) {
                      setState(() {
                        widget.candidate.isHired = '0';
                      });
                    }
                  }
                },
                child: Text('Reject Candidate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ] else ...[
              // If candidate is neither hired nor scheduled for an interview
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  String? companyId = await getCompanyId();
                  if (companyId != null) {
                    bool success = await updateHiringStatus(
                        widget.candidate.id, companyId, 'Short Listed', '3');
                    if (success) {
                      setState(() {
                        widget.candidate.isHired = '3';
                      });
                    }
                  }
                },
                child: Text('Add To Short List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
            SizedBox(height: 8),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Gender', widget.candidate.gender),
                    _buildDetailRow('Age', '${widget.candidate.age}'),
                    _buildDetailRow('Region', widget.candidate.region),
                    _buildDetailRow(
                        'Place of Birth', widget.candidate.placeOfBirth),
                    _buildDetailRow('Phone', widget.candidate.phone),
                    _buildDetailRow(
                        'Job Category', widget.candidate.jobCategory),
                    _buildDetailRow(
                        'Sub Job Category', widget.candidate.subJobCategory),
                    _buildDetailRow(
                        'Skills', widget.candidate.skills ?? 'Not Available'),
                    _buildDetailRow('About Me',
                        widget.candidate.aboutMe ?? 'Not Available'),
                    _buildDetailRow(
                        'Date of Birth', widget.candidate.dateOfBirth),
                    _buildDetailRow('Email', widget.candidate.email),
                    _buildDetailRow('City', widget.candidate.city),
                    _buildDetailRow(
                        'Qualification', widget.candidate.qualification),
                    _buildDetailRow(
                        'Years of Experience', widget.candidate.experience),
                    // Add other fields as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build rows for candidate details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
