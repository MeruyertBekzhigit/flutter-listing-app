import 'package:flutter/material.dart';
import 'package:sample_listing_app/utils.dart';

import '../models/launch.dart';

class LaunchListPage extends StatelessWidget {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');
  List<Launch> launches = Utils.getMockedLaunches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SpaceX launches'),
        ),
        body: ListView.builder(
         itemCount: launches.length,
          itemBuilder: (BuildContext ctx, int index) {
           return Container(
             margin: EdgeInsets.all(20),
             height: 150,
             child: ListTile(
                      leading: Icon(Icons.map),
                      title: Text(launches[index].name),
                      subtitle: Text(launches[index].date),
                      trailing: Icon(star)
                  ),


           );
          }
        ),
      );
  }
}