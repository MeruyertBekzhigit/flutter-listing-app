import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/utils.dart';
import 'package:http/http.dart' as http;

import '../models/launch.dart';

Future<List<Launch>> getLaunchData() async {
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

class LaunchListPage extends StatefulWidget {
  const LaunchListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LaunchListPageState();
  }
}

class LaunchListPageState extends State<LaunchListPage> {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');
  List<Launch> mockLaunches = Utils.getMockedLaunches();
  late Future<List<Launch>> realtimeLaunches;
  List<String> favoriteLaunches = [];

  @override
  void initState() {
    loadAndStoreLaunches();
    super.initState();
  }

  void loadAndStoreLaunches() {
    realtimeLaunches = getLaunchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e8e8),
      appBar: AppBar(
        title: const Text('SpaceX launches'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Launch>>(
        future: realtimeLaunches,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final launches = snapshot.data as List<Launch>;
              return ListView.builder(
                  itemCount: launches.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    Launch launchItem = launches[index];
                    bool isAmongFavourites =
                        favoriteLaunches.contains(launchItem.id);
                    return Container(
                        color: const Color(0xffbbbcbd),
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        padding: const EdgeInsets.only(
                            left: 5, top: 20, right: 5, bottom: 10),
                        child: ListTile(
                            leading: const Icon(
                              Icons.auto_graph,
                              size: 50,
                            ),
                            title: Text(
                              launchItem.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.stars_sharp),
                              iconSize: 32.0,
                              color: isAmongFavourites
                                  ? Colors.amber
                                  : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  isAmongFavourites
                                      ? favoriteLaunches.remove(launchItem.id)
                                      : favoriteLaunches.add(launchItem.id);
                                });
                              },
                            ),
                            onTap: () {}));
                  });
            } else {
              return Center(
                child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                          "Unexpected error occurred. Please tap to retry"),
                    ),
                    onTap: () => setState(() {
                          loadAndStoreLaunches();
                        })),
              );
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          }
        },
      ),
    );
  }
}
