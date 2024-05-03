import 'package:flutter/material.dart';

import 'app_button_state.dart';
import 'decorators/app_button_decorator.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {required String title,
      required Function? onClick,
      AppButtonState appButtonState = AppButtonState.enabled,
      Color? backgroundColor,
      Color? textColor,
      double height = 40,
      double radius = 20,
      double elevation = 2,
      double fontSize = 16.0,
      double? width,
      AppButtonDecorator? button,
      BorderSide? border,
      EdgeInsets? padding,
      Widget? icon,
      bool hasUnderline = false,
      TextStyle? buttonTextStyle,
      super.key})
      : _title = title,
        _appButtonState = appButtonState,
        _backgroundColor = backgroundColor,
        _textColor = textColor,
        _height = height,
        _radius = radius,
        _elevation = elevation,
        _fontSize = fontSize,
        _button = button,
        _onClick = onClick,
        _icon = icon,
        _border = border,
        _padding = padding,
        _hasUnderline = hasUnderline,
        _buttonTextStyle = buttonTextStyle,
        _width = width;
  final String _title;
  final AppButtonState _appButtonState;
  final Function? _onClick;
  final Color? _backgroundColor;
  final Color? _textColor;
  final double _height;
  final double? _width;
  final double _radius;
  final double _elevation;
  final double _fontSize;
  final AppButtonDecorator? _button;
  final BorderSide? _border;
  final Widget? _icon;
  final EdgeInsets? _padding;
  final bool _hasUnderline;
  final TextStyle? _buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: _padding ?? const EdgeInsets.symmetric(horizontal: 5),
      onPressed:
          _appButtonState == AppButtonState.disabled ? null : _onButtonClick,
      shape: RoundedRectangleBorder(
          side: _border ?? BorderSide.none,
          borderRadius: BorderRadius.circular(_radius)),
      height: _height,
      elevation: _elevation == 0
          ? 0
          : (_appButtonState != AppButtonState.disabled ? 2.0 : _elevation),
      color: _button?.getBackgroundColor(context, _appButtonState) ??
          _backgroundColor ??
          Theme.of(context).colorScheme.primary,
      textColor: _button?.getTitleColor(_appButtonState) ?? _textColor,
      disabledColor:
          _button?.getBackgroundColor(context, AppButtonState.disabled) ??
              _backgroundColor ??
              Theme.of(context).colorScheme.primary,
      disabledTextColor:
          _button?.getTitleColor(AppButtonState.disabled) ?? _textColor,
      minWidth: _width ?? double.infinity,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      highlightColor:
          _button?.getBackgroundColor(context, AppButtonState.tapped) ??
              _backgroundColor ??
              Theme.of(context).colorScheme.primary,
      enableFeedback: false,
      child: SizedBox(
        width: _width ?? double.infinity,
        height: _height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_icon != null) _icon,
            if (_icon != null)
              const SizedBox(
                width: 4,
              ),
            Text(
              _title,
              style: _buttonTextStyle ??
                  TextStyle(
                      color: (_textColor == null)
                          ? _button?.getTitleColor(_appButtonState) ??
                              Theme.of(context).colorScheme.onPrimary
                          : _textColor,
                      decoration:
                          _hasUnderline ? TextDecoration.underline : null),
            ),
          ],
        ),
      ),
    );
  }

  void _onButtonClick() {
    _onClick?.call();
  }
}
