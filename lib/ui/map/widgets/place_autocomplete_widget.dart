import 'package:apple_maps/helpers/map_platform_helper.dart';
import 'package:apple_maps/main_export.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class PlaceAutoComplete extends StatefulWidget {
  const PlaceAutoComplete({
    required this.viewId,
    required this.onSelectPlace,
    super.key,
  });

  final int? viewId;
  final ValueNotifier<(double, double, String)?> onSelectPlace;

  @override
  State<PlaceAutoComplete> createState() => _PlaceAutoCompleteState();
}

class _PlaceAutoCompleteState extends State<PlaceAutoComplete> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  static const int _debouncePrediction = 400;
  static const double _textfieldHeigh = 60;
  static const double _paddingTopTextfield = 70;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _paddingTopTextfield,
      left: Ui.paddingL.left,
      right: Ui.paddingL.right,
      child: _buildAutoCompleteTextField(),
    );
  }

  Widget _buildAutoCompleteTextField() {
    return Container(
      padding: Ui.horizontalPaddingN,
      child: GooglePlaceAutoCompleteTextField(
        focusNode: _focusNode,
        boxDecoration:
            const BoxDecoration(color: Colors.white, boxShadow: Ui.boxShadow),
        textEditingController: _controller,
        googleAPIKey: Constants.googleMapsApiKey,
        inputDecoration: InputDecoration(
          hintText: 'Wyszukaj swoją lokalizacje'.hardcoded,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: _debouncePrediction,
        getPlaceDetailWithLatLng: _getPlaceDetailWithLatLng,
        itemBuilder: _buildPredictionItem,
        itemClick: _onItemClick,
        containerHorizontalPadding: Ui.horizontalPaddingS.horizontal,
      ),
    );
  }

  Future<void> _getPlaceDetailWithLatLng(Prediction prediction) async {
    //clear previous marker
    await MapPlatformHelper.clearAllMarkers(widget.viewId!);
    //unfocus keyboard
    _focusNode.unfocus();

    final lat = double.tryParse(prediction.lat!);
    final lng = double.tryParse(prediction.lng!);
    if (lat != null && lng != null && widget.viewId != null) {
      //callback to preview Ui to show navigate container
      widget.onSelectPlace.value = (lat, lng, prediction.description!);
      //add marker to map
      await MapPlatformHelper.addMarker(
        widget.viewId!,
        lat,
        lng,
        prediction.description!,
      );
      //animate to position
      await MapPlatformHelper.animateToPosition(widget.viewId!, lat, lng);
    }
  }

  Widget _buildPredictionItem(
    BuildContext context,
    int index,
    Prediction prediction,
  ) {
    return Container(
      height: _textfieldHeigh,
      decoration:
          const BoxDecoration(color: Colors.white, boxShadow: Ui.boxShadow),
      padding: Ui.paddingL,
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
          ),
          gapH8,
          Expanded(child: Text(prediction.description ?? '')),
          Icon(
            Icons.arrow_right,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  void _onItemClick(Prediction prediction) {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller
      ..text = prediction.description ?? ''
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: prediction.description?.length ?? 0),
      );
  }
}
