import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter/material.dart';

showSnackbar(BuildContext context, String message) {
  showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: message));
}
