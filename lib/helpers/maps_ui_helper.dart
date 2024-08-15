import 'package:apple_maps/common/custom_toast.dart';
import 'package:apple_maps/main_export.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsUiHelper {
  /// this widget show FlutterModal when user tap on Native Swift Marker
  static Future<dynamic> showOnTapMarkerDialog(
    BuildContext context,
    String markerTitle,
    double lat,
    double lng,
  ) {
    return showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: Sizes.p48,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(markerTitle),
              gapH8,
              Text('Lat: $lat'),
              gapH8,
              Text('Lng: $lng'),
            ],
          ),
          actions: <Widget>[
            FilledButton(
              child: Text('Otwórz w Apple Maps'.hardcoded),
              onPressed: () async {
                final mapUri = Uri.parse('https://maps.apple.com/?q=$lat,$lng');
                if (!await launchUrl(
                  mapUri,
                  mode: LaunchMode.externalApplication,
                )) {
                  if (context.mounted) {
                    CustomToast.error(context, 'Nie udało się otworzyć map');
                  }
                }
              },
            ),
            TextButton(
              child: Text('Wyjdź'.hardcoded),
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
