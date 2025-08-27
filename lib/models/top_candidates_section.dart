import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CandidatesSection extends StatefulWidget {
  const CandidatesSection({Key? key}) : super(key: key);

  @override
  _CandidatesSectionState createState() => _CandidatesSectionState();
}

class _CandidatesSectionState extends State<CandidatesSection> {
  List<dynamic> candidates = [];

  @override
  void initState() {
    super.initState();
    fetchTopCandidates();
  }

  Future<void> fetchTopCandidates() async {
    final response = await http.get(
      Uri.parse(
          'http://your-server-address/fetch_top_candidates.php'), // Replace with your server address
    );

    if (response.statusCode == 200) {
      setState(() {
        candidates = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load candidates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (candidates.isEmpty)
          const Center(child: Text('No Candidates Found'))
        else
          ...candidates.map((candidate) {
            return CandidateCard(
              idUser: candidate['id_user'],
              firstName: candidate['firstname'],
              lastName: candidate['lastname'],
              profileImage: candidate['profileimage'],
              avgRating: candidate['avg_rating'],
            );
          }).toList(),
      ],
    );
  }
}

class CandidateCard extends StatelessWidget {
  final String idUser;
  final String firstName;
  final String lastName;
  final String profileImage;
  final int avgRating;

  const CandidateCard({
    required this.idUser,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.avgRating,
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
              backgroundImage: NetworkImage(
                'http://www.jijethiopia.com/$profileImage', // Replace with your server address
              ),
              radius: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < avgRating ? Colors.amber : Colors.grey,
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
