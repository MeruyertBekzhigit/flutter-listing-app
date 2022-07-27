import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/api_service.dart';
import 'package:sample_listing_app/helpers/utils.dart';

import '../models/launch.dart';
import '../models/payload.dart';

enum DataFetchState { loading, error, hasData }

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
  List<Payload> mockPayloads = Utils.getMockedPayloads();

  late Future<List<Launch>> realtimeLaunches;
  List<String> favoriteLaunchIds = [];
  List<String> expandedLaunchIds = [];
  List<DataFetchState> payloadStates = [];
  DataFetchState currentState = DataFetchState.loading;

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
        // future: realtimeLaunches,
        future: Future.value(Utils.getMockedLaunches()),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final launches = snapshot.data as List<Launch>;
              return buildLaunchList(context, launches);
            } else {
              return _ExtractedLaunchErrorIndicator(onTap: () {
                setState(() {
                  loadAndStoreLaunches();
                });
              });
            }
          } else {
            return buildLoading(context);
          }
        },
      ),
    );
  }

  Widget buildLaunchList(BuildContext context, List<Launch> launches) {
    return ListView.builder(
      itemCount: launches.length,
      itemBuilder: (BuildContext ctx, int index) {
        Launch launchItem = launches[index];

        bool isExpanded = expandedLaunchIds.contains(launchItem.id);
        return Column(
          children: [
            buildListItemHeader(
                ctx, launchItem, () => print('Index is $index')),
            // pass the states of layout loading
            if (isExpanded) buildPayloadsContainer(context)
          ],
        );
      },
    );
  }

  Widget buildListItemHeader(
    BuildContext context,
    Launch launchItem,
    VoidCallback onExpandRequested,
  ) {
    bool isMarkedAsFavourite = favoriteLaunchIds.contains(launchItem.id);
    bool isExpanded = expandedLaunchIds.contains(launchItem.id);
    return Container(
      color: const Color(0xffbbbcbd),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      padding: const EdgeInsets.only(
        left: 5,
        top: 20,
        right: 5,
        bottom: 10,
      ),
      child: ListTile(
        leading: const Icon(Icons.auto_graph, size: 50),
        title: Text(
          launchItem.name,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.stars_sharp),
          iconSize: 32.0,
          color: isMarkedAsFavourite ? Colors.amber : Colors.grey,
          onPressed: () {
            setState(() {
              updateFavoriteState(isMarkedAsFavourite, launchItem.id);
            });
          },
        ),
        onTap: () {
          setState(() {
            // notify that onClickHappened
            onExpandRequested();
            if (isExpanded) {
              expandedLaunchIds.remove(launchItem.id);
            } else {
              expandedLaunchIds.add(launchItem.id);
            }
          });
        },
      ),
    );
  }

  // pass states here
  Widget buildPayloadsContainer(BuildContext context) {
    if (currentState == DataFetchState.loading) {
      return buildLoading(context);
    } else if (currentState == DataFetchState.hasData) {
      return Container(
        color: Colors.yellow,
        height: 100,
        margin: const EdgeInsets.only(left: 10, right: 10),
      );
    } else {
      return _ExtractedLaunchErrorIndicator(onTap: () {
        setState(() {
          loadAndStoreLaunches();
        });
      });
    }
  }

  Widget buildLoading(BuildContext context) => const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );

  void updateFavoriteState(bool isMarkedAsFavorite, String id) {
    if (isMarkedAsFavorite) {
      favoriteLaunchIds.remove(id);
    } else {
      favoriteLaunchIds.add(id);
    }
  }
}

class _ExtractedLaunchErrorIndicator extends StatelessWidget {
  final VoidCallback onTap;

  const _ExtractedLaunchErrorIndicator({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("Unexpected error occurred. Please tap to retry"),
        ),
      ),
    );
  }
}
