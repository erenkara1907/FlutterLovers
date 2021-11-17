import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/common_widget/%20platform_responsive_widget/platform_responsive_widget.dart';

class ResponsiveAlertDialog extends PLatformResponsiveWidget {
  final String title;
  final String content;
  final String baseButtonText;
  final String? backButtonText;

  ResponsiveAlertDialog({
    required this.title,
    required this.content,
    required this.baseButtonText,
    this.backButtonText,
  });

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonSettings(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonSettings(context),
    );
  }

  List<Widget> _dialogButtonSettings(BuildContext context) {
    final List<Widget> allButons = [];

    if (Platform.isIOS) {
      if (backButtonText != null) {
        allButons.add(
          CupertinoDialogAction(
            child: Text(backButtonText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButons.add(
        CupertinoDialogAction(
          child: Text(baseButtonText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (backButtonText != null) {
        allButons.add(
          ElevatedButton(
            child: Text(backButtonText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButons.add(
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(baseButtonText),
        ),
      );
    }

    return allButons;
  }
}
