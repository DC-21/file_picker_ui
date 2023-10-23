import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SelectedFilesModel extends ChangeNotifier {
  List<PlatformFile> selectedFiles = [];

  void setSelectedFiles(List<PlatformFile> files) {
    selectedFiles = files;
    notifyListeners();
  }
}
