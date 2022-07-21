import '../models/launch.dart';

class Utils {
  static List<Launch> getMockedLaunches() {
    return [
      Launch(name: "Trailblazer", date: "2021.01.21 - 19:30"),
      Launch(name: "CRS-21", date: "2021.02.15 - 5:30"),
      Launch(name: "Stardust-5", date: "2021.02.15 - 5:30"),
      Launch(name: "Stardust-6", date: "2021.04.12 - 21:00"),
    ];
  }
}
