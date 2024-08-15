import 'package:apple_maps/helpers/map_platform_helper.dart';
import 'package:apple_maps/ui/navigate_container.dart';
import 'package:apple_maps/ui/place_autocomplete_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apple Maps Simple Implementation',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int? _viewId;

  final ValueNotifier<(double, double, String)?> _onSelectPlace =
      ValueNotifier(null);

  @override
  void initState() {
    super.initState();
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
            const Center(
              child: CircularProgressIndicator(),
            ),
          NavigateContainer(onSelectPlace: _onSelectPlace, viewId: _viewId)
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

class MapView extends StatelessWidget {
  //callback function to save viewId used in method channel
  final Function(int) onPlatformViewCreated;

  const MapView({required this.onPlatformViewCreated, super.key});

  @override
  Widget build(BuildContext context) {
    ///This widget use native swift injection view
    ///function call this widget [MapPlatformHelper] and in
    ///folder [IOS] inside [AppDelegate.swift] and [FLNativeView.swift]
    return UiKitView(
      viewType: 'SwiftUIView',
      layoutDirection: TextDirection.ltr,
      creationParams: const <String, dynamic>{},
      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: onPlatformViewCreated,
    );
  }
}
