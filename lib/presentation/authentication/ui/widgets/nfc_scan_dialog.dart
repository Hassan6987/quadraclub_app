import 'dart:convert';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/teams/bloc/teams_bloc.dart';

class NfcScanDialog extends StatefulWidget {
  final VoidCallback? onSuccess;
  final void Function(String nfcId)? onScan;

  const NfcScanDialog({super.key, this.onSuccess, this.onScan});

  @override
  State<NfcScanDialog> createState() => _NfcScanDialogState();
}

class _NfcScanDialogState extends State<NfcScanDialog>
    with WidgetsBindingObserver {
  String _statusMessage = "Hold your wristband near the back of your phone";
  bool _isScanning = true;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startNfcSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (!_hasCompleted) {
      FlutterNfcKit.finish(iosAlertMessage: "Cancelled").catchError((e) {
        debugPrint("Error finishing NFC in dispose: $e");
      });
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isScanning && !_hasCompleted) {
      debugPrint("App resumed, NFC scanning active");
    } else if (state == AppLifecycleState.paused && !_hasCompleted) {
      FlutterNfcKit.finish(iosAlertMessage: "Paused").catchError((e) {
        debugPrint("Error finishing NFC on pause: $e");
      });
    }
  }

  Future<void> _startNfcSession() async {
    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        if (mounted) {
          setState(() {
            _statusMessage = "NFC is not available on this device";
            _isScanning = false;
          });
          _showErrorAndClose(
            "NFC is not available or disabled on this device",
            context,
          );
        }
        return;
      }

      NFCTag tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 20),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your wristband",
        androidPlatformSound: false,
        // Disable system sound
        androidCheckNDEF: false,
        // Important: prevents Samsung's default NDEF reader
        readIso15693: false,
        readIso18092: false,
      );

      debugPrint("Tag found: ${jsonEncode(tag)}");

      String nfcId = tag.id;
      if (nfcId.isNotEmpty) {
        debugPrint("NFC UID detected: $nfcId");

        // Mark as completed BEFORE finishing NFC
        _hasCompleted = true;

        // Finish NFC session BEFORE any navigation
        try {
          await FlutterNfcKit.finish(iosAlertMessage: "Success");
        } catch (e) {
          debugPrint("Error finishing NFC: $e");
          // Continue anyway since we got the data
        }

        // Small delay to ensure NFC session is properly closed
        await Future.delayed(const Duration(milliseconds: 100));

        if (!mounted) return;
        widget.onScan != null
            ? widget.onScan!(nfcId)
            : context.read<TeamsBloc>().add(ScanTeamNFC(nfcId: nfcId));

        Navigator.of(context).pop();
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
      } else {
        _hasCompleted = true;

        try {
          await FlutterNfcKit.finish(iosAlertMessage: "Failed");
        } catch (e) {
          debugPrint("Error finishing NFC: $e");
        }

        if (mounted) {
          setState(() {
            _statusMessage = "Failed to read NFC tag. Please try again.";
            _isScanning = false;
          });
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      debugPrint("NFC Error: $e");
      _hasCompleted = true;

      try {
        await FlutterNfcKit.finish(iosAlertMessage: "Error");
      } catch (finishError) {
        debugPrint("Error finishing NFC after error: $finishError");
      }

      if (!mounted) return;
      _showErrorAndClose("Error reading NFC tag: $e", context);
    }
  }

  void _showErrorAndClose(String message, BuildContext ctx) {
    ctx.showToast(message, isError: true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(ctx).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop && !_hasCompleted) {
          try {
            await FlutterNfcKit.finish(iosAlertMessage: "Cancelled");
          } catch (e) {
            debugPrint("Error finishing NFC on pop: $e");
          }
        }
      },
      child: AlertDialog(
        backgroundColor: kWhiteColor,
        surfaceTintColor: kWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: const BoxConstraints(minHeight: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isScanning)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    strokeWidth: 4,
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                style: AppStyles.titleMedium.copyWith(color: kBlackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
