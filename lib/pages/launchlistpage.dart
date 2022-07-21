import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/utils.dart';
import 'package:http/http.dart' as http;

import '../models/launch.dart';

Future<Launch> getLaunchData() async {
  final response =
      await http.get(Uri.parse('https://api.spacexdata.com/v4/launches'));

  if (response.statusCode == 200) {
    var decodedFilteredLaunch = jsonDecode(response.body);
    var firstElement = decodedFilteredLaunch[0];
    Map<String, dynamic> launchMap = firstElement;
    return Launch.fromJson(launchMap);
  } else {
    throw Exception('Failed to load launches');
  }
}

class LaunchListPage extends StatefulWidget {
  const LaunchListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LaunchListPageState();
  }
}

class LaunchListPageState extends State<LaunchListPage> {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');
  late Future<Launch> futureLaunch;
  List<Launch> launches = Utils.getMockedLaunches();

  @override
  void initState() {
    futureLaunch = getLaunchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e8e8),
      appBar: AppBar(
        title: const Text('SpaceX launches'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: launches.length,
          itemBuilder: (BuildContext ctx, int index) {
            return Container(
              color: const Color(0xffbbbcbd),
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              padding:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
              child: FutureBuilder<Launch>(
                  future: futureLaunch,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                          leading: const Icon(
                            Icons.auto_graph,
                            size: 50,
                          ),
                          title: Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onTap: () {
                            /* react to the tile being tapped */
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  }),
            );
          }),
    );
  }
}
