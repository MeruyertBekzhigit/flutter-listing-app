import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/utils.dart';
import 'package:http/http.dart' as http;

import '../models/launch.dart';

class LaunchListPage extends StatelessWidget {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');
  List<Launch> launches = Utils.getMockedLaunches();

  Future getLaunchData() async {
    var response = await http.get(Uri.https('api.spacexdata.com', 'v4/launches'));
    var jsonData = jsonDecode(response.body);
    List<Launch> fetchedLaunches = [];

    for (var data in jsonData){
      Launch launch = Launch(name: data['name'], date: data['date_utc'], payloadNumber: data['payloads']);
      fetchedLaunches.add(launch);
    }
    print(fetchedLaunches.length);
    return fetchedLaunches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SpaceX launches'),
        ),
        body: ListView.builder(
         itemCount: launches.length,
          itemBuilder: (BuildContext ctx, int index) {
           return ListTile(
             leading: Icon(Icons.auto_graph),
             title: Text(launches[index].name),
             subtitle: Text(launches[index].date),
             trailing:  const IconButton(
               icon: Icon(Icons.stars_sharp),
               tooltip: 'Search',
               color: Colors.yellow,
               onPressed: null,
             ),
               onTap: () { /* react to the tile being tapped */ print("CELL IS TAPPED"); }
           );
          }
        ),
      );
  }
}