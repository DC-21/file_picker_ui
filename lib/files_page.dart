import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class FilesPage extends StatelessWidget {
  final List<PlatformFile> files;

  const FilesPage({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Selected Files'),
          centerTitle: true,
        ),
        body: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return buildFile(file);
            },
          ),
        ));
  }
}

Widget buildFile(PlatformFile file) {
  final kb = file.size / 1024;
  final mb = kb / 1024;
  final fileSize =
      mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  final extension = file.extension ?? 'none';
  final color = getColor(extension);

  return InkWell(
    onTap: () => openFile(file),
    child: Container(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '.$extension',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            file.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            fileSize,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

Color getColor(String extension) {
  final extensionColors = {
    'pdf': Colors.red,
    'docx': Color.fromARGB(255, 13, 9, 236),
    // Add more extensions and colors as needed.
  };

  return extensionColors[extension] ?? Colors.grey;
}

void openFile(PlatformFile file) async {
  try {
    final result = await OpenFile.open(file.path);
    if (result.type == ResultType.done) {
      // File has been opened successfully.
    } else if (result.type == ResultType.noAppToOpen) {
      // No app available to open this file type.
      print("No app available to open ${file.name}");
    } else {
      // Error opening the file.
      print("Error opening file: ${result.message}");
    }
  } catch (e) {
    // Handle exceptions
    print("Error opening file: $e");
  }
}
