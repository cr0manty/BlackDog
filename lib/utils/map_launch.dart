import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

class MapUtils {
  static Future<void> openMap(
      double latitude, double longitude, String title) async {

    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(latitude, longitude),
        title: title,
      );
    } else {
      final availableMaps = await MapLauncher.installedMaps;
      print(
          availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(latitude, longitude),
        title: title,
      );
    }
  }
}
