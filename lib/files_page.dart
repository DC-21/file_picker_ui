import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:power/results_page.dart';

class FilesPage extends StatefulWidget {
  final List<PlatformFile> files;

  const FilesPage({Key? key, required this.files}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  bool isScanning = false;

  void _scanNow(BuildContext context) async {
    if (isScanning) {
      return;
    }

    setState(() {
      isScanning = true;
    });

    print('Files to be sent:');

    // Define the API endpoint URL.
    final apiUrl = Uri.parse('https://similarity-checks-server.onrender.com/upload');

    try {
      final request = http.MultipartRequest('POST', apiUrl);

      for (var file in widget.files) {
        final fileBytes = await File(file.path!).readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            fileBytes,
            contentType: MediaType(
              'application',
              'vnd.openxmlformats-officedocument.wordprocessingml.document',
            ),
            filename: file.name,
          ),
        );

        print(file.name);
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        print('Scan successful');
        final responseData = await response.stream.bytesToString();
        print('Response Data: $responseData');

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResponsePage(responseJson: responseData),
        ));
      } else {
        print('Error scanning files. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error scanning files: $e');
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Selected Files",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.deepPurple],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final file = widget.files[index];
                return buildFile(file);
              },
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () => _scanNow(context),
              child: isScanning
                  ? const CircularProgressIndicator() // Show loader while scanning
                  : const Text('Scan Now'),
            ),
          ),
          const SizedBox(
            height: 18,
          )
        ],
      ),
    );
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
    'docx': Colors.blue,
  };

  return extensionColors[extension] ?? Colors.grey;
}

void openFile(PlatformFile file) async {
  try {
    final result = await OpenFile.open(file.path);
    if (result.type == ResultType.done) {
    } else if (result.type == ResultType.noAppToOpen) {
      print("No app available to open ${file.name}");
    } else {
      print("Error opening file: ${result.message}");
    }
  } catch (e) {
    print("Error opening file: $e");
  }
}
