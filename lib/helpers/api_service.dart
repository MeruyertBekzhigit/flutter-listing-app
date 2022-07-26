import 'dart:convert';

import 'package:sample_listing_app/models/launch.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  const ApiService();
  Future<List<Launch>> getLaunches();
}

class RealAPI extends ApiService {
  @override
  Future<List<Launch>> getLaunches() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/launches'));

    if (response.statusCode == 200) {
      var decodedFilteredLaunch = jsonDecode(response.body);
      List<dynamic> jsonResponse = decodedFilteredLaunch;
      List<Launch> launches =
          jsonResponse.map((json) => Launch.fromJson(json)).toList();

      return launches;
    } else {
      throw Exception('Failed to load launches');
    }
  }
}

class MockAPI extends RealAPI {
  var counter = 0;

  @override
  Future<List<Launch>> getLaunches() async {
    // Simulating the HTTP call
    await Future.delayed(const Duration(seconds: 2));
    counter += 1;

    if (counter == 1) {
      throw Exception('Failed to load launches');
    } else {
      return super.getLaunches();
    }
  }
}
