import 'package:apple_maps/helpers/map_platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigateContainer extends StatelessWidget {
  const NavigateContainer({
    super.key,
    required ValueNotifier<(double, double, String)?> onSelectPlace,
    required int? viewId,
  })  : _onSelectPlace = onSelectPlace,
        _viewId = viewId;

  final ValueNotifier<(double, double, String)?> _onSelectPlace;
  final int? _viewId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _onSelectPlace,
      builder: (context, value, child) {
        if (value == null) {
          return const SizedBox();
        }
        return Positioned(
          bottom: 70,
          left: 20,
          right: 20,
          child: ElevatedButton(
              onPressed: () {
                MapPlatformHelper.animateToPosition(
                    _viewId!, value.$1, value.$2);
                final url = Uri.parse(
                    'https://maps.apple.com/?daddr=${value.$1},${value.$2}');
                launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.navigation),
                    const SizedBox(width: 10),
                    Expanded(
                        child: RichText(
                      text: TextSpan(
                        text: 'Prowadź do\n',
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: value.$3,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              )),
        );
      },
    );
  }
}
