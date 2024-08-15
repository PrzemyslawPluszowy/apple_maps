import 'package:apple_maps/helpers/map_platform_helper.dart';
import 'package:apple_maps/main_export.dart';
import 'package:apple_maps/ui/map/widgets/map_view.dart';
import 'package:apple_maps/ui/map/widgets/navigate_container.dart';
import 'package:apple_maps/ui/map/widgets/place_autocomplete_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int? _viewId;

  ///[_onSelectPlace] set to not null when user tap on element in places list
  ///then show info container
  ///refreshing after clic on next item

  final ValueNotifier<(double, double, String)?> _onSelectPlace =
      ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    ///Initialize to listening native tap marker and open flutter dialog
    MapPlatformHelper.initializeMethodChannel(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapView(onPlatformViewCreated: _onPlatformViewCreated),
          if (_viewId != null)
            PlaceAutoComplete(
              viewId: _viewId,
              onSelectPlace: _onSelectPlace,
            )
          else
            Center(
              child: Text(
                'Przepraszamy, Nie udało sie załadować widoku'.hardcoded,
              ),
            ),
          NavigateContainer(onSelectPlace: _onSelectPlace, viewId: _viewId),
        ],
      ),
    );
  }

  void _onPlatformViewCreated(int viewId) {
    setState(() {
      _viewId = viewId;
    });
  }
}
