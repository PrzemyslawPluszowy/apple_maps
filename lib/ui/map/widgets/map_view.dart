import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapView extends StatelessWidget {
  const MapView({required this.onPlatformViewCreated, super.key});
  //callback function to save viewId used in method channel
  final void Function(int) onPlatformViewCreated;

  ///Don't change directly this [_viewType] used to identify in [ios/AppDelegate]
  static const _viewType = 'SwiftMapView';

  @override
  Widget build(BuildContext context) {
    ///This widget use native swift injection view
    ///function call this widget [MapPlatformHelper] and in
    ///folder [IOS] inside [AppDelegate.swift] and [FLNativeView.swift]
    return UiKitView(
      viewType: _viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: const <String, dynamic>{},
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: onPlatformViewCreated,
    );
  }
}
