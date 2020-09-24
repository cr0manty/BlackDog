import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/map_launch.dart';
import 'package:black_dog/widgets/about_section.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/status_bar_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
              style: Utils.instance.getTextStyle('headline1')),
          content: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                child: AboutSection(
                  config.address,
                  SFSymbols.placemark_fill,
                  itemWidth: ScreenSize.modalMaxTextWidth,
                  horizontalPadding: 0,
                  color: HexColor.errorLog,
                  onTap: () {
                    try {
                      MapUtils.openMap(
                          config.lat, config.lon, config.branchName);
                    } catch (e) {
                      print(e);
                      Navigator.of(context).pop();
                      EasyLoading.instance
                        ..backgroundColor = Colors.red.withOpacity(0.8);
                      EasyLoading.showError('');
                    }
                  },
                ),
              ),
              AboutSection(
                config.weekdayWorkingTime(context),
                SFSymbols.clock_fill,
                itemWidth: ScreenSize.modalMaxTextWidth,
                horizontalPadding: 0,
              ),
              AboutSection(
                  config.weekendWorkingTime(context), SFSymbols.clock_fill,
                  itemWidth: ScreenSize.modalMaxTextWidth,
                  horizontalPadding: 0),
              AboutSection(config.branchPhone, SFSymbols.phone_fill,
                  itemWidth: ScreenSize.modalMaxTextWidth,
                  call: true,
                  horizontalPadding: 0)
            ],
          ),
        ));
  }

  void _addMarkers() {
    _restaurants.forEach((config) {
      if (config.lat == null || config.lon == null) {
        return;
      }
      LatLng position = LatLng(config.lat, config.lon);
      final MarkerId markerId = MarkerId('${config.id}');

      setState(() {
        markers[markerId] = Marker(
          markerId: markerId,
          position: position,
          onTap: () => _showModal(config),
        );
      });
    });
  }

  LatLng get _initPosition => LatLng(49.989128, 36.230987);

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (popUpOnScreen != null) {
            setState(() {
              popUpOnScreen = null;
            });
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _initPosition,
                  zoom: 12,
                ),
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
                  onTap: () => Navigator.of(context).pop(),
                )),
            StatusBarColor(),
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
