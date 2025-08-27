import 'package:flutter/material.dart';
import 'candidate.dart';
import 'widget/CandidatesList.dart';
import 'widget/StarRating.dart';
import 'widget/filterForm.dart';
import 'CandidateDetailsScreen.dart';

class CandidatesShortListScreen extends StatefulWidget {
  @override
  _CandidatesShortListScreenState createState() =>
      _CandidatesShortListScreenState();
}

class _CandidatesShortListScreenState extends State<CandidatesShortListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  late Future<List<Candidate>> _candidatesFuture;

  @override
  void initState() {
    super.initState();
    _candidatesFuture =
        fetchShorListedCandidates(); // Fetch candidates from your API
  }

  /*void _applyFilters(String state, String city, String jobCategory,
      String subJobCategory, String experience) {
    // TODO: Update your API call or local data filtering logic here
    setState(() {
      _candidatesFuture = fetchFilteredCandidates(
          state, city, jobCategory, subJobCategory, experience);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUST IN JOB'),
        backgroundColor: Colors.yellow[700], // Match the color from the image
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters Section using FilterForm
            /*Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterForm(
                      onApplyFilters: _applyFilters,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),*/

            Expanded(
              child: FutureBuilder<List<Candidate>>(
                future: _candidatesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No candidates found'));
                  }

                  List<Candidate> candidates = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      final candidate = candidates[index];
                      final profileImageUrl = candidate.profilePictureUrl !=
                              null
                          ? 'https://www.jijethiopia.com/${candidate.profilePictureUrl}'
                          : null;
                      String defaultAvatar = candidate.gender == 'Female'
                          ? 'assets/images/avatar_female.jpg'
                          : 'assets/images/avatar_male.jpg';

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Column to stack the avatar and star rating vertically
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: profileImageUrl != null &&
                                            profileImageUrl.isNotEmpty
                                        ? NetworkImage(profileImageUrl)
                                        : AssetImage(defaultAvatar)
                                            as ImageProvider,
                                    radius: 30,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  SizedBox(
                                      height:
                                          8), // Space between avatar and star rating
                                  StarRating(
                                    rating: candidate.rating,
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidate.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Gender: ${candidate.gender}'),
                                    SizedBox(height: 8),
                                    Text('Region: ${candidate.region}'),
                                    SizedBox(height: 8),
                                    Text('City: ${candidate.city}'),
                                    SizedBox(height: 8),
                                    Text(
                                      'Job Category: ${getFirstValue(candidate.jobCategory)}',
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Sub Job Category: ${getFirstValue(candidate.subJobCategory)}',
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Experience: ${candidate.experience}',
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Status: ${candidate.status}',
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Payment Status: Free Trial',
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigate to CandidateDetailsScreen when the button is pressed
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CandidateDetailsScreen(
                                                    candidate: candidate),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 8),
                                      ),
                                      child: Text('View Details'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get the first value from a comma-separated string
  String getFirstValue(String value) {
    final values = value.split(',').map((s) => s.trim()).toList();
    return values.isNotEmpty ? values[0] : '';
  }
}
