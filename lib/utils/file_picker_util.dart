import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerUtil {
  /// Pick documents (PDF, DOC, DOCX)
  static Future<File?> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      log("FilePickerUtil.pickDocument error: $e");
    }
    return null;
  }

  /// Pick videos
  static Future<File?> pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      log("FilePickerUtil.pickVideo error: $e");
    }
    return null;
  }
}
