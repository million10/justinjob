import 'dart:convert';
import 'package:http/http.dart' as http;
import '../candidate.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Retrieve id_company from SharedPreferences
Future<String?> getCompanyId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('id_company');
} // Import your Candidate model

Future<List<Candidate>> fetchCandidates() async {
  try {
    final String? idCompany = await getCompanyId();

    if (idCompany == null) {
      // Handle the case where idCompany is not set
      print('No company ID found.');
      return [];
    }

    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/fetchCandidates.php?id_company=$idCompany'));
    //print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Candidate.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load candidates');
    }
  } catch (e) {
    print('Error fetching Candidates data: ${e.toString()}');
    // Return an empty list in case of an error
    return [];
  }
}

Future<List<Candidate>> fetchShorListedCandidates() async {
  try {
    final String? idCompany = await getCompanyId();

    if (idCompany == null) {
      // Handle the case where idCompany is not set
      print('No company ID found.');
      return [];
    }

    final response = await http.get(Uri.parse(
        'https://www.jijethiopia.com/mobileapp/fetchShortListedCandidates.php?id_company=$idCompany'));
    print('Status Code: ${response.statusCode}');

    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Candidate.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load candidates');
    }
  } catch (e) {
    print('Error fetching Candidates data: ${e.toString()}');
    // Return an empty list in case of an error
    return [];
  }
}

Future<List<Candidate>> fetchFilteredCandidates(String state, String city,
    String jobCategory, String subJobCategory, String experience) async {
  try {
    final String? idCompany = await getCompanyId();

    if (idCompany == null) {
      print('No company ID found.');
      return [];
    }

    // Construct the query parameters
    final queryParameters = {
      'id_company': idCompany,
      'state': state,
      'city': city,
      'job_category': jobCategory,
      'sub_job_category': subJobCategory,
      'experience': experience,
    };

    // Remove empty parameters
    queryParameters.removeWhere((key, value) => value.isEmpty);
    print(
        'Fetching candidates with URL: ${Uri.parse('https://www.jijethiopia.com/mobileapp/fetchCandidates.php').replace(queryParameters: queryParameters)}');

    // Make the API call with query parameters
    final response = await http.get(
      Uri.parse('https://www.jijethiopia.com/mobileapp/fetchCandidates.php')
          .replace(queryParameters: queryParameters),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Candidate.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load filtered candidates');
    }
  } catch (e) {
    print('Error fetching filtered candidates: $e');
    return [];
  }
}
