import 'package:map_launcher/map_launcher.dart';

import 'debug_print.dart';

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
      debugPrefixPrint(availableMaps, prefix: 'map'); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(latitude, longitude),
        title: title,
      );
    }
  }
}
