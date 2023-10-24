import 'package:flutter/material.dart';
import 'dart:convert';

class ResponsePage extends StatelessWidget {
  final String responseJson;

  const ResponsePage({Key? key, required this.responseJson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the JSON response into a Dart object
    final response = json.decode(responseJson);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Response Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 54, 33, 243),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the icon (back button) color to white
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "${response["message"]}",
                style: const TextStyle(
                  fontSize: 20, // Adjust the font size as needed
                  fontWeight: FontWeight
                      .normal, // You can change the fontWeight as well
                ),
              ),
            ),
            if (response["similarities"] != null &&
                response["similarities"].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response["similarities"].map<Widget>((similarity) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("File 1: ${similarity["file1"]}"),
                      Text("File 2: ${similarity["file2"]}"),
                      if (similarity.containsKey("similarParagraphs"))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              (similarity["similarParagraphs"] as List<dynamic>)
                                  .map<Widget>((paragraph) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(paragraph.toString()),
                            );
                          }).toList(),
                        ),
                      const Divider(), // Add a divider
                    ],
                  );
                }).toList(),
              )
            else
              const Text("No similarities found."),
            if (response["differences"] != null &&
                response["differences"].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response["differences"].map<Widget>((difference) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("File 1: ${difference["file1"]}"),
                      Text("File 2: ${difference["file2"]}"),
                      Text("Message: ${difference["message"]}"),
                      const Divider(), // Add a divider
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
