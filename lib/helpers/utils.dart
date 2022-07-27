import 'package:sample_listing_app/models/payload.dart';

import '../models/launch.dart';

class Utils {
  static List<Launch> getMockedLaunches() {
    return [
      const Launch(
          id: "1",
          name: "Trailblazer",
          date: "2021.01.21 - 19:30",
          payloads: []),
      const Launch(
          id: "2", name: "CRS-21", date: "2021.02.15 - 5:30", payloads: []),
      const Launch(
          id: "3", name: "Stardust-5", date: "2021.02.15 - 5:30", payloads: []),
      const Launch(
          id: "4",
          name: "Stardust-6",
          date: "2021.04.12 - 21:00",
          payloads: []),
    ];
  }

  static List<Payload> getMockedPayloads() {
    return [
      const Payload(name: "RazakSAT", type: "Satellite"),
      const Payload(name: "PreSAT", type: "Satellite"),
      const Payload(name: "10SAT", type: "Satellite"),
      const Payload(name: "Dragon", type: "Satellite")
    ];
  }
}
