import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'models/conversion_request.dart';

void main() => runApp(CodeConverterApp());

class CodeConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SourceCodeScreen(),
    );
  }
}

class SourceCodeScreen extends StatefulWidget {
  @override
  _SourceCodeScreenState createState() => _SourceCodeScreenState();
}

class _SourceCodeScreenState extends State<SourceCodeScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _convertCode() async {
    try {
      ConversionRequest conversionRequest = ConversionRequest(
        source: _sourceController.text,
        target: _targetController.text,
        code: _codeController.text,
      );

      final response = await http.post(
        Uri.parse('http://localhost:5001/convert'),
        body: conversionRequest.toMap(),
      );

      final responseData = json.decode(response.body);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConvertedCodeScreen(output: responseData['output'])
      ));
    } catch (e) {
      if (e is FormatException) {
        print('Failed to decode JSON. Invalid format: $e');
      } else {
        print('An unexpected error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(SOURCE_CODE_SCREEN_TITLE)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: SOURCE_LANGUAGE_LABEL),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _targetController,
              decoration: InputDecoration(labelText: TARGET_LANGUAGE_LABEL),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: INPUT_CODE_LABEL),
              maxLines: 8,
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _convertCode, child: Text(CONVERT_CODE_BUTTON_TEXT)),
          ],
        ),
      ),
    );
  }
}

class ConvertedCodeScreen extends StatelessWidget {
  final String output;

  ConvertedCodeScreen({required this.output});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(CONVERTED_CODE_SCREEN_TITLE)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(CONVERTED_CODE_TEXT, style: TextStyle(fontSize: 20, color: Colors.green)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: SingleChildScrollView(child: Text(output)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
