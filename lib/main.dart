import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SwiftUIView(),
    );
  }
}

class SwiftUIView extends StatefulWidget {
  const SwiftUIView({super.key});

  @override
  State<SwiftUIView> createState() => _SwiftUIViewState();
}

class _SwiftUIViewState extends State<SwiftUIView> {
  late TextEditingController controller;
  static const platform = MethodChannel('com.example/map');
  int? _viewId;

  late final FocusNode _focusNode;

  @override
  void initState() {
    controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const viewType = 'SwiftUIView';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Material(
      child: Stack(
        children: [
          UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int viewId) {
              setState(() {
                _viewId = viewId;
              });
            },
          ),
          Positioned(
            top: 70,
            left: 10,
            right: 10,
            child: placesAutoCompleteTextField(),
          ),
        ],
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        focusNode: _focusNode,
        boxDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        textEditingController: controller,
        googleAPIKey: "AIzaSyALMjn-8OAWj9GDT6GUABXY_tfzNqIHDgI",
        inputDecoration: const InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) async {
          _focusNode.unfocus();

          final double? lat = double.tryParse(prediction.lat!);
          final double? lng = double.tryParse(prediction.lng!);
          if (lat != null && lng != null && _viewId != null) {
            _addMarker(_viewId!, lat, lng, prediction.description!);

            _animateToPosition(_viewId!, lat, lng);
          }
        },
        itemClick: (Prediction prediction) {
          FocusManager.instance.primaryFocus?.unfocus();

          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 10,
        isCrossBtnShown: true,
      ),
    );
  }

  Future<void> _animateToPosition(int viewId, double lat, double lng) async {
    try {
      await platform.invokeMethod('animateToLocation', <String, dynamic>{
        'viewId': viewId,
        'lat': lat,
        'lng': lng,
      });
    } on PlatformException catch (e, s) {
      print(s);
      print("Failed to animate to position: '${e.message}'.");
    }
  }

  Future<void> _addMarker(
      int viewId, double lat, double lng, String title) async {
    try {
      await platform.invokeMethod('addMarker', <String, dynamic>{
        'viewId': viewId,
        'lat': lat,
        'lng': lng,
        'title': title,
      });
    } on PlatformException catch (e, s) {
      print(s);
      print("Failed to add marker: '${e.message}'.");
    }
  }
}
