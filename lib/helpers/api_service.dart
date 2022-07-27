import 'dart:convert';

import 'package:sample_listing_app/helpers/utils.dart';
import 'package:sample_listing_app/models/launch.dart';
import '../models/payload.dart';

import 'package:http/http.dart' as http;

abstract class ApiService {
  const ApiService();
  Future<List<Launch>> getLaunches();
  Future<Payload> getPayloadById(String id);
  Future<List<Payload>> getPayloadsByIds(List<String> id);
}

class RealAPI extends ApiService {
  @override
  Future<List<Launch>> getLaunches() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/launches'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Launch> launches =
          jsonResponse.map((json) => Launch.fromJson(json)).toList();

      return launches;
    } else {
      throw Exception('Failed to load launches');
    }
  }

  @override
  Future<Payload> getPayloadById(String id) async {
    final response = await http
        .get(Uri.parse('https://api.spacexdata.com/v4/payloads/${id}'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Payload.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load payloads');
    }
  }

  @override
  Future<List<Payload>> getPayloadsByIds(List<String> id) {
    // TODO: Iterate through each of them and only return if every payload is done (Future.wait  -> you can pass a List)
    throw UnimplementedError();
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

  @override
  Future<List<Payload>> getPayloadsByIds(List<String> id) async {
    // TODO: implement getPayloadsByIds
    await Future.delayed(const Duration(seconds: 2));
    return Utils.getMockedPayloads();
  }
}
