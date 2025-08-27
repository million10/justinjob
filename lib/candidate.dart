class Candidate {
  final String id; // Add this field
  final String name;
  final String gender;
  final String dateOfBirth;
  final String age;
  final String placeOfBirth;
  final String phone;
  final String email;
  final String region;
  final String city;
  final String jobCategory;
  final String subJobCategory;
  final double rating;
  final String experience;
  final String skills;
  final String qualification;
  final String aboutMe;
  final String status;
  final String? profilePictureUrl;
  String isHired;

  Candidate({
    required this.id, // Add this field
    required this.name,
    required this.gender,
    required this.age,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.region,
    required this.city,
    required this.jobCategory,
    required this.subJobCategory,
    required this.rating,
    required this.experience,
    required this.skills,
    required this.qualification,
    required this.aboutMe,
    required this.status,
    required this.isHired,
    this.profilePictureUrl,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    try {
      return Candidate(
        id: json['id_user'] ?? '0', // Add this field
        name: json['firstname'] ?? 'Unknown',
        gender: json['sex'] ?? 'Unknown',
        age: json['age'].toString() ?? 'N/A',
        placeOfBirth: json['place_of_birth'] ?? 'Unknown',
        dateOfBirth: json['dob'] ?? 'Unknown',
        phone: json['contactno'] ?? 'N/A',
        email: json['email'] ?? '',
        region: json['state'] ?? 'Unknown',
        city: json['city'] ?? 'Unknown',
        jobCategory: json['job_category'] ?? 'Uncategorized',
        subJobCategory: json['sub_job_category'].toString().trim() ?? '',
        rating: json['average_rating'] != null
            ? double.tryParse(json['average_rating'].toString()) ?? 0.0
            : 0.0, // Convert to double or default to 0.0
        experience: json['experience'] ?? 'No experience',
        skills: json['skills'] ?? 'Not specified',
        qualification: json['qualification'] ?? 'Not specified',
        aboutMe: json['aboutme'] ?? '',
        status: json['status'] ?? '',
        isHired: json['is_hired'] ?? '',
        profilePictureUrl:
            json['profileimage'] != null ? json['profileimage'] : null,
      );
    } catch (e) {
      print('Error parsing candidate: $e');
      throw Exception('Failed to parse Candidate: $e');
    }
  }
}
