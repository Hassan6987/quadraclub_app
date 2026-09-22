import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class SafeAreaWrapper extends StatefulWidget {
  final Widget child;

  const SafeAreaWrapper({super.key, required this.child});

  @override
  State<SafeAreaWrapper> createState() => _SafeAreaWrapperState();
}

class _SafeAreaWrapperState extends State<SafeAreaWrapper> {
  bool isAndroid14OrAbove = false;

  @override
  void initState() {
    super.initState();
    _checkAndroidVersion();
  }

  Future<void> _checkAndroidVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final is14OrAbove = androidInfo.version.sdkInt > 34;
      setState(() {
        isAndroid14OrAbove = is14OrAbove;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: isAndroid14OrAbove,
      right: false,
      left: false,
      child: widget.child,
    );
  }
}
