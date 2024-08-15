import 'package:apple_maps/helpers/maps_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///all method call platform channel from [FLNativeView]
/// and register in [AppDelegate]
/// used to controlling apple maps from native view

class MapPlatformHelper {
  /// [mapChannel] and [mapChannel] are used to identify
  /// chanel in [AppDelegate] if you modify this values You
  /// must change in [AppDelegate] !!!!!!!!!!!!

  static const MethodChannel mapChannel = MethodChannel('com.example/map');
  static const MethodChannel markerChannel =
      MethodChannel('com.example/map_marker_click');

  static void initializeMethodChannel(BuildContext context) {
    markerChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onMarkerClick':
          await onMarkerClick(context, call.arguments);
          break;
        default:
          throw MissingPluginException(
              'Niezaimplementowana metoda: ${call.method}');
      }
    });
  }

  static Future<void> animateToPosition(
      int viewId, double lat, double lng) async {
    try {
      await mapChannel.invokeMethod('animateToLocation', {
        'viewId': viewId,
        'lat': lat,
        'lng': lng,
      });
    } on PlatformException catch (e) {
      debugPrint("Błąd podczas animowania do pozycji: '${e.message}'.");
    }
  }

  static Future<void> addMarker(
      int viewId, double lat, double lng, String title) async {
    try {
      await mapChannel.invokeMethod('addMarker', {
        'viewId': viewId,
        'lat': lat,
        'lng': lng,
        'title': title,
      });
    } on PlatformException catch (e) {
      debugPrint("Błąd podczas dodawania markera: '${e.message}'.");
    }
  }

  static Future<void> clearAllMarkers(int viewId) async {
    try {
      await mapChannel.invokeMethod('clearAllMarkers', {
        'viewId': viewId,
      });
    } on PlatformException catch (e) {
      debugPrint("Błąd podczas czyszczenia markerów: '${e.message}'.");
    }
  }

  static Future<void> onMarkerClick(
      BuildContext context, dynamic arguments) async {
    final String markerTitle = arguments['title'];
    final double lat = arguments['lat'];
    final double lng = arguments['lng'];

    ///open flutter dialog
    MapsUiHelper.showOnTapMarkerDialog(context, markerTitle, lat, lng);
  }
}
