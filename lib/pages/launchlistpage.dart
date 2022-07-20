import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/utils.dart';
import 'package:http/http.dart' as http;

import '../models/launch.dart';

class LaunchListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LaunchListPageState();
  }
}

class LaunchListPageState extends State<LaunchListPage> {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');
  List<Launch> launches = Utils.getMockedLaunches();

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
             padding: const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
             child: Column(
               children: [
                 ListTile(
                     leading: const Icon(
                       Icons.auto_graph,
                       size: 50,
                     ),
                     title: Text(
                       launches[index].name,
                       style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.black
                       ),
                     ),
                     onTap: () { /* react to the tile being tapped */ print("CELL IS TAPPED"); }
                 ),
               ],
             )
           );
          }
        ),
      );
  }
}

