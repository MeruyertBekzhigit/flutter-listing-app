import 'package:flutter/material.dart';
import 'package:sample_listing_app/pages/launchlistpage.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
      home: const LaunchListPage()));
}
