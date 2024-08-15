import 'package:apple_maps/core/extension/context_color.dart';
import 'package:apple_maps/core/extension/context_text_theme.dart';
import 'package:apple_maps/core/utils/platfroms.dart';
import 'package:apple_maps/main_export.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void success(BuildContext context, String message) {
    if (isIOS || isWeb || isAndroid) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: context.textTheme.titleSmall?.fontSize,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void error(BuildContext context, String message) {
    if (isIOS || isWeb || isAndroid) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: context.colorScheme.error,
        textColor: context.colorScheme.surface,
        fontSize: context.textTheme.titleSmall?.fontSize,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void custom({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required double fontSize,
    required ToastGravity gravity,
  }) {
    if (isIOS || isWeb || isAndroid) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void errWithoutContext(String message) {
    Fluttertoast.showToast(
      fontSize: Sizes.p24,
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
