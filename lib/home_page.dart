import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:power/files_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _selectAndOpenFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null || result.files.isEmpty) return;

    final files = result.files;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FilesPage(files: files),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ai Scanner"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectAndOpenFiles,
            child: const Text("Select Files"),
          ),
        ),
      ),
    );
  }
}
