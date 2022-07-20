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
  var isSelectedAsFavourite = false;
  int _selectedIndex = 0;
  bool _customTileExpanded = false;

  bool isExpanded = false;

  Future getLaunchData() async {
    var response = await http.get(Uri.https('api.spacexdata.com', 'v4/launches'));
    var jsonData = jsonDecode(response.body);
    List<Launch> fetchedLaunches = [];

    for (var data in jsonData){
      Launch launch = Launch(name: data['name'], date: data['date_utc'], payloadNumber: data['payloads']);
      fetchedLaunches.add(launch);
    }
    return fetchedLaunches;
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
             padding: const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
             child: Column(
               children: [
                 ListTile(
                     selected: index == _selectedIndex,
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
                     subtitle: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         const SizedBox(height: 10),
                         Text(
                           launches[index].date,
                           style: const TextStyle(
                               fontWeight: FontWeight.normal,
                               color: Colors.black
                           ),
                         ),
                       ],
                     ),
                     trailing: IconButton(
                       icon: const Icon(Icons.stars_sharp),
                       tooltip: 'Search',
                       iconSize: 32.0,
                       color: (index == _selectedIndex && isSelectedAsFavourite) ? Colors.amber : Colors.grey,
                       onPressed: () {
                         setState(() //<--whenever icon is pressed, force redraw the widget
                         {
                           _selectedIndex = index;
                           isSelectedAsFavourite  = !isSelectedAsFavourite;
                         }
                         );
                       },
                     ),
                     onTap: () { /* react to the tile being tapped */ print("CELL IS TAPPED"); }
                 ),
                   Container(
                     color: Colors.white,
                     child: buildExpansionPanel(context),
                   ),
               ],
             )
           );
          }
        ),
      );
  }

  @override
  Widget buildExpansionPanel(BuildContext context) => const ExpansionTile(
    title: Text('Payload count: 2'),
    children: [
      Text(
        'RazakSAT',
        style: TextStyle(
          fontSize: 16,
          height: 1.4,
        ),
        textAlign: TextAlign.left,
      ),
      Text(
        'PreSAT',
        style: TextStyle(
          fontSize: 16,
          height: 1.4,
        ),
        textAlign: TextAlign.left,
      )
    ],
  );
}

