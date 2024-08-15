import 'package:apple_maps/helpers/map_platform_helper.dart';
import 'package:apple_maps/main_export.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigateContainer extends StatelessWidget {
  const NavigateContainer({
    required ValueNotifier<(double, double, String)?> onSelectPlace,
    required int? viewId,
    super.key,
  })  : _onSelectPlace = onSelectPlace,
        _viewId = viewId;

  final ValueNotifier<(double, double, String)?> _onSelectPlace;
  final int? _viewId;

  static const Duration _animateDuration = Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _onSelectPlace,
      builder: (context, value, child) {
        if (value == null) {
          return const SizedBox();
        }
        return Positioned(
          bottom: Sizes.p72,
          left: Ui.horizontalPaddingN.left,
          right: Ui.horizontalPaddingN.right,
          child: ElevatedButton(
            onPressed: () {
              MapPlatformHelper.animateToPosition(
                _viewId!,
                value.$1,
                value.$2,
              );
              final url = Uri.parse(
                'https://maps.apple.com/?daddr=${value.$1},${value.$2}',
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: Sizes.p48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.navigation),
                  gapH8,
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Prowadź do\n'.hardcoded,
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: value.$3,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(
            onPlay: (controller) {
              controller.repeat(reverse: true);
            },
          ).shimmer(
            colors: [
              Colors.transparent,
              Theme.of(context).primaryColor.withOpacity(0.5),
              Colors.transparent,
            ],
            duration: _animateDuration,
          ),
        );
      },
    );
  }
}
