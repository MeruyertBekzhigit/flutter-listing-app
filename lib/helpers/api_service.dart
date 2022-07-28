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
  Future<List<Payload>> getPayloadsByIds(List<String> ids) async {
    List<Payload> finalItems = [];

    await Future.wait(ids.map((id) async {
      Payload finalItem = await getPayloadById(id);
      finalItems.add(finalItem);
    }).toList());

    return finalItems;
  }
}

class MockAPI extends RealAPI {
  var launchFetchAttemptCounter = 0;
  var payloadFetchAttemptCounter = 1;

  @override
  Future<List<Launch>> getLaunches() async {
    // Simulating the HTTP call
    await Future.delayed(const Duration(seconds: 2));
    launchFetchAttemptCounter += 1;

    if (launchFetchAttemptCounter == 1) {
      throw Exception('Failed to load launches');
    } else {
      return super.getLaunches();
    }
  }

  @override
  Future<List<Payload>> getPayloadsByIds(List<String> ids) async {
    // Simulating the HTTP call
    await Future.delayed(const Duration(seconds: 2));
    payloadFetchAttemptCounter += 1;

    if (payloadFetchAttemptCounter == 1) {
      throw Exception('Failed to load launches');
    } else {
      return super.getPayloadsByIds(ids);
    }
  }
}
