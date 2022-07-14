import 'models/launch.dart';

class Utils {
  static List<Launch> getMockedLaunches() {
    return [
      Launch(
        name: "Trailblazer",
        date: "2021.01.21 - 19:30",
        icon: "ttps://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
        payloadNumber: "5"
      ),
      Launch(
          name: "CRS-21",
          date: "2021.02.15 - 5:30",
          icon: "ttps://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
          payloadNumber: "2"
      ),
      Launch(
          name: "Stardust-5",
          date: "2021.02.15 - 5:30",
          icon: "ttps://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
          payloadNumber: "10"
      ),
      Launch(
          name: "Stardust-6",
          date: "2021.04.12 - 21:00",
          icon: "ttps://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
          payloadNumber: "2"
      ),
    ];
  }
}