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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "${response["message"]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (response["similarities"] != null &&
                response["similarities"].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response["similarities"].map<Widget>((similarity) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "File 1: ${similarity["file1"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "File 2: ${similarity["file2"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Similarity Percentage: ${similarity["averageSimilarityPercentage"].toStringAsFixed(2)}%",
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      if (similarity.containsKey("plagiarismMessage"))
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 10),
                          child: Text(
                            similarity["plagiarismMessage"],
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        "Source: ${similarity["copyingDirection"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (similarity.containsKey("similarParagraphs"))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              (similarity["similarParagraphs"] as List<dynamic>)
                                  .map<Widget>((paragraph) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                paragraph.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      const Divider(),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              )
            else
              const Text(
                "No similarities found.",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (response["differences"] != null &&
                response["differences"].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response["differences"].map<Widget>((difference) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "File 1: ${difference["file1"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "File 2: ${difference["file2"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
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
