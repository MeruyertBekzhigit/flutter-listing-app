import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/api_service.dart';
import 'package:sample_listing_app/helpers/utils.dart';

import '../models/launch.dart';

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
  List<String> favoriteLaunchIds = [];
  List<String> expandedLaunchItems = [];
  ApiService api = MockAPI();

  @override
  void initState() {
    loadAndStoreLaunches();
    super.initState();
  }

  void loadAndStoreLaunches() {
    realtimeLaunches = api.getLaunches();
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
                return buildLaunchLoadingSuccessWidget(context, launches);
              } else {
                return ExtractedLoadingErrorWidget(onTap: () {
                  setState(() {
                    loadAndStoreLaunches();
                  });
                });
              }
            } else {
              return buildLaunchLoadingWidget(context);
            }
          }),
    );
  }

  Widget buildLaunchLoadingSuccessWidget(
          BuildContext context, List<Launch> launches) =>
      ListView.builder(
          itemCount: launches.length,
          itemBuilder: (BuildContext ctx, int index) {
            Launch launchItem = launches[index];
            bool isMarkedAsFavourite =
                favoriteLaunchIds.contains(launchItem.id);
            bool isExpanded = expandedLaunchItems.contains(launchItem.id);
            return Column(
              children: [
                Container(
                    color: const Color(0xffbbbcbd),
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
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
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.stars_sharp),
                          iconSize: 32.0,
                          color:
                              isMarkedAsFavourite ? Colors.amber : Colors.grey,
                          onPressed: () {
                            setState(() {
                              toggleFavorites(
                                  isMarkedAsFavourite, launchItem.id);
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            isExpanded
                                ? expandedLaunchItems.remove(launchItem.id)
                                : expandedLaunchItems.add(launchItem.id);
                          });
                        })),
                if (isExpanded) buildLayoutsContainer(context)
              ],
            );
          });

  Widget buildLayoutsContainer(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: 100,
      margin: const EdgeInsets.only(left: 10, right: 10),
    );
  }

  Widget buildLaunchLoadingWidget(BuildContext context) => const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );

  void toggleFavorites(bool isMarkedAsFavorite, String id) {
    isMarkedAsFavorite
        ? favoriteLaunchIds.remove(id)
        : favoriteLaunchIds.add(id);
  }
}

class ExtractedLoadingErrorWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ExtractedLoadingErrorWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
            child: const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("Unexpected error occurred. Please tap to retry"),
            ),
            onTap: () {
              onTap();
            }));
  }
}
