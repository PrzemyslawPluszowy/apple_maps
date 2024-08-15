import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

///all method call platform channel from [FLNativeView]
/// and register in [AppDelegate]
/// used to controlling apple maps from native view

class MapPlatformHelper {
  static const MethodChannel platform = MethodChannel('com.example/map');
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
      await platform.invokeMethod('animateToLocation', {
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
      await platform.invokeMethod('addMarker', {
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
      await platform.invokeMethod('clearAllMarkers', {
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

class MapsUiHelper {
  /// this widget show FlutterModal when user tap on Native Swift Marker
  static Future<dynamic> showOnTapMarkerDialog(
      BuildContext context, String markerTitle, double lat, double lng) {
    return showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(markerTitle),
          actions: <Widget>[
            FilledButton(
                child: const Text('Otwórz w Apple Maps'),
                onPressed: () async {
                  final Uri mapUri =
                      Uri.parse('https://maps.apple.com/?q=$lat,$lng');
                  if (!await launchUrl(mapUri,
                      mode: LaunchMode.externalApplication)) {
                    throw Exception('Could not launch ');
                  }
                }),
            TextButton(
              child: const Text('Wyjdź'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
