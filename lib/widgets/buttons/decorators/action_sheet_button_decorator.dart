import 'package:flutter/material.dart';

import '../app_button_state.dart';
import 'app_button_decorator.dart';

class ActionSheetButtonDecorator extends AppButtonDecorator {
  double backgroundOpacity = 1;
  @override
  Color getBackgroundColor(
      BuildContext context, AppButtonState appButtonState) {
    switch (appButtonState) {
      case AppButtonState.enabled:
        return Theme.of(context).colorScheme.onSecondary;
      case AppButtonState.tapped:
        return Theme.of(context).colorScheme.onSecondary;
      case AppButtonState.disabled:
        return Theme.of(context).colorScheme.onSecondary;
    }
  }

  @override
  Color getTitleColor(AppButtonState appButtonState) {
    return Colors.white;
  }
}
