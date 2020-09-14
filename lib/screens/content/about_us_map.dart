import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/about_section.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutUsMapPage extends StatefulWidget {
  @override
  _AboutUsMapPageState createState() => _AboutUsMapPageState();
}

class _AboutUsMapPageState extends State<AboutUsMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription _connectionChange;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<RestaurantConfig> _restaurants;
  Future popUpOnScreen;

  void _showModal(RestaurantConfig config) {
    popUpOnScreen = showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text(config.branchName,
              style: Theme.of(context).textTheme.headline1),
          content: Column(
            children: [
              AboutSection(
                config.weekdayWorkingTime(context),
                SFSymbols.clock_fill,
                horizontalPadding: 0,
              ),
              AboutSection(
                  config.weekendWorkingTime(context), SFSymbols.clock_fill,
                  horizontalPadding: 0),
              AboutSection(
                config.address,
                SFSymbols.placemark_fill,
                horizontalPadding: 0,
                color: HexColor.errorLog,
              ),
              AboutSection(config.branchPhone, SFSymbols.phone_fill,
                  call: true, horizontalPadding: 0)
            ],
          ),
        )).then((value) => setState(() => popUpOnScreen = null));
  }

  void _addMarkers() {
    _restaurants.forEach((config) {
      if (config.lat == null || config.lon == null) {
        return;
      }
      final MarkerId markerId = MarkerId('${config.id}');

      setState(() {
        markers[markerId] = Marker(
          markerId: markerId,
          position: LatLng(config.lat, config.lat),
          onTap: () => _showModal(config),
        );
      });
    });
  }

  CameraPosition _initCamera = CameraPosition(
    target: LatLng(Account.instance.position.longitude,
        Account.instance.position.latitude),
    zoom: 12,
  );

  @override
  void initState() {
    _restaurants = SharedPrefs.getAboutUsList();
    _addMarkers();

    if (ConnectionsCheck.instance.isOnline) {
      getConfigList();
    }

    _connectionChange =
        ConnectionsCheck.instance.onChange.listen((_) => getConfigList());
    super.initState();
  }

  Future getConfigList() async {
    Api.instance.getRestaurantConfig(limit: 100).then((value) {
      _restaurants = SharedPrefs.getAboutUsList();
      _addMarkers();
      _addTest();
    });
  }

  void _addTest() {
    if (_restaurants.length > 0) {
      setState(() {
        _restaurants[0].lat = 50.0300067;
        _restaurants[0].lon = 36.2793358;
      });
    }

    _addMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: popUpOnScreen != null ? Navigator.of(context).pop : null,
        child: Stack(
          children: [
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initCamera,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set<Marker>.of(markers.values)),
            Positioned(
                top: MediaQuery.of(context).padding.top,
                child: RouteButton(
                  defaultIcon: true,
                  text: AppLocalizations.of(context).translate('about_us'),
                  color: HexColor.darkElement,
                  textColor: HexColor.lightElement,
                  iconColor: HexColor.lightElement,
                  onTap: Navigator.of(context).pop,
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectionChange?.cancel();
    super.dispose();
  }
}