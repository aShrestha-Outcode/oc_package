import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton(
      {required IconData icon,
      required Function? onClick,
      Color? backgroundColor,
      double height = 48,
      Color? iconColor,
      Color? shadowColor,
      bool isCircular = false,
      double angle = 0,
      double spreadRadius = 3,
      bool hasShadow = true,
      double iconScale = 0.8,
      double cornerRadius = 10,
      Border? border,
      super.key})
      : _icon = icon,
        _backgroundColor = backgroundColor,
        _height = height,
        _iconColor = iconColor,
        _onClick = onClick,
        _shadowColor = shadowColor,
        _isCircular = isCircular,
        _cornerRadius = cornerRadius,
        _angle = angle,
        _spreadRadius = spreadRadius,
        _hasShadow = hasShadow,
        _iconScale = iconScale,
        _border = border;
  final IconData _icon;
  final Function? _onClick;
  final Color? _backgroundColor;
  final Color? _shadowColor;
  final double _height;
  final Color? _iconColor;
  final bool _isCircular;
  final double _spreadRadius;
  final bool _hasShadow;
  final double _iconScale;
  final double _angle;
  final double _cornerRadius;
  final Border? _border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _height,
      height: _height,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: _border,
          borderRadius: BorderRadius.all(
              Radius.circular(_isCircular ? _height / 2.0 : _cornerRadius)),
          boxShadow: _hasShadow
              ? [
                  BoxShadow(
                    color: _shadowColor?.withOpacity(0.2) ??
                        Theme.of(context).shadowColor,
                    spreadRadius: _spreadRadius,
                    blurRadius: 3,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Align(
            child: AnimatedRotation(
              turns: _angle,
              duration: const Duration(milliseconds: 100),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _icon,
                  size: _height * _iconScale,
                  color: _iconColor,
                ),
                onPressed: () {
                  _onClick?.call();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
