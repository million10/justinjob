import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://www.jijethiopia.com/mobileapp';

  Future<List<String>> fetchStates() async {
    final response = await http.get(Uri.parse('$baseUrl/fetchStates.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e['state'] as String).toList();
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCandidates({
    String? city,
    String? state,
    String? jobCategory,
    String? subJobCategory,
    String? experience,
  }) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/fetchCandidates.php?city=$city&state=$state&job_category=$jobCategory&sub_job_category=$subJobCategory&experience=$experience'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load candidates');
    }
  }
}
