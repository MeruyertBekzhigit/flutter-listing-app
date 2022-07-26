import '../models/launch.dart';

class Utils {
  static List<Launch> getMockedLaunches() {
    return [
      Launch(
          id: "1",
          name: "Trailblazer",
          date: "2021.01.21 - 19:30",
          payloads: []),
      Launch(id: "2", name: "CRS-21", date: "2021.02.15 - 5:30", payloads: []),
      Launch(
          id: "3", name: "Stardust-5", date: "2021.02.15 - 5:30", payloads: []),
      Launch(
          id: "4",
          name: "Stardust-6",
          date: "2021.04.12 - 21:00",
          payloads: []),
    ];
  }
}
