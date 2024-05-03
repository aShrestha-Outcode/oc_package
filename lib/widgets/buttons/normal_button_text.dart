import 'package:flutter/material.dart';

class NormalTextButton extends StatelessWidget {
  const NormalTextButton(
      {required this.title,
      this.textColor,
      this.onClick,
      this.isEnabled = true,
      super.key});
  final String title;
  final Function()? onClick;
  final Color? textColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Text(
        title,
        style: TextStyle(
            color: textColor ?? Theme.of(context).primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
