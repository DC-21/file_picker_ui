import 'package:flutter/material.dart';
import 'dart:convert';

class ResponsePage extends StatelessWidget {
  final String responseJson;

  const ResponsePage({super.key, required this.responseJson});

  @override
  Widget build(BuildContext context) {
    // Parse the JSON response into a Dart object
    final response = json.decode(responseJson);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Response Page"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Message: ${response["message"]}"),
            if (response["similarities"].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response["similarities"].map<Widget>((similarity) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("File 1: ${similarity["file1"]}"),
                      Text("File 2: ${similarity["file2"]}"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: similarity["similarParagraphs"]
                            .map<Widget>((paragraph) {
                          return Text(paragraph);
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              )
            else
              const Text("No similarities found."),
          ],
        ),
      ),
    );
  }
}
