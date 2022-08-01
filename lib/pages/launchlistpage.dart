import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_listing_app/helpers/api_service.dart';

import '../models/launch.dart';
import '../models/payload.dart';

enum DataFetchState { none, loading, error, hasData }

class LaunchListPage extends StatefulWidget {
  const LaunchListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LaunchListPageState();
  }
}

class LaunchListPageState extends State<LaunchListPage> {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');

  Map<String, List<Payload>> mappedPayloads = {};

  late Future<List<Launch>> realtimeLaunches;

  List<String> favoriteLaunchIds = [];
  List<String> expandedLaunchIds = [];

  List<DataFetchState> payloadStates = [];

  ApiService api = RealAPI();

  @override
  void initState() {
    loadAndStoreLaunches();
    super.initState();
  }

  Future<void> loadAndStoreLaunches() async {
    realtimeLaunches = api.getLaunches();

    final launches = await realtimeLaunches;
    payloadStates =
        List.generate(launches.length, (index) => DataFetchState.none);
  }

  Future<void> _loadPayloadsForLaunchIfNecessary(
      Launch launch, int index) async {
    final currentState = payloadStates[index];

    switch (currentState) {
      case DataFetchState.none:
      case DataFetchState.error:
        try {
          setState(() => payloadStates[index] = DataFetchState.loading);
          final payloads = await api.getPayloadsByIds(launch.payloadIds);
          mappedPayloads[launch.id] = payloads;
          setState(() => payloadStates[index] = DataFetchState.hasData);
        } catch (e) {
          setState(() => payloadStates[index] = DataFetchState.error);
        }
        break;

      default:
        break;
    }
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
              return buildExpandableLaunchList(context, launches);
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
    final items = List.generate(
        launches.length,
        (index) =>
            buildListItemHeader(context: context, launchItem: launches[index]));
    return ListView(children: items);
  }

  Widget buildExpandableLaunchList(
      BuildContext context, List<Launch> launches) {
    final items = List.generate(
      launches.length,
      (index) => ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Text(launches[index].name);
        },
        body: buildPayloadsContainer(context, payloadStates[index],
            mappedPayloads[launches[index].id] ?? [], () {
          setState(() {
            _loadPayloadsForLaunchIfNecessary(launches[index], index);
          });
        }),
        isExpanded: expandedLaunchIds.contains(launches[index].id),
      ),
    );
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            if (!isExpanded) {
              expandedLaunchIds.add(launches[index].id);
            } else {
              expandedLaunchIds.remove(launches[index].id);
            }
          });
        },
        children: items,
      ),
    );
  }

  Widget buildListItemHeader(
      {required BuildContext context, required Launch launchItem}) {
    bool isMarkedAsFavourite = favoriteLaunchIds.contains(launchItem.id);
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
        onTap: () {},
      ),
    );
  }

  Widget buildPayloadsContainer(BuildContext context, DataFetchState state,
      List<Payload> payloads, VoidCallback retryFetch) {
    if (state == DataFetchState.loading) {
      return Container(
        color: Colors.white,
        height: 80,
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: buildLoading(context),
      );
    } else if (state == DataFetchState.hasData) {
      return Column(
        children: [
          for (var i in payloads)
            Text(
              i.name.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
        ],
      );
    } else {
      return _ExtractedLaunchErrorIndicator(onTap: retryFetch);
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
