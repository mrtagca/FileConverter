import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfToWordPage extends StatefulWidget {
  const PdfToWordPage({super.key});

  @override
  State<PdfToWordPage> createState() => _PdfToWordPageState();
}

class _PdfToWordPageState extends State<PdfToWordPage> {
  String? resultPath;

  Future<void> convertPdfToWord() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.path == null) return;

    final pdfBytes = File(result.files.single.path!).readAsBytesSync();

    final document = PdfDocument(inputBytes: pdfBytes);
    final text = PdfTextExtractor(document).extractText();

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF içeriği çözümlenemedi.")),
      );
      return;
    }

    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) return;

    final fileName = 'converted_${DateTime.now().millisecondsSinceEpoch}.docx';
    final outputPath = '$directoryPath/$fileName';

    final outputFile = File(outputPath);
    await outputFile.writeAsString(text);

    setState(() {
      resultPath = outputPath;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Word dosyası başarıyla kaydedildi:\n$outputPath")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF to Word")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: convertPdfToWord,
              child: const Text("PDF Seç ve Word'e Dönüştür"),
            ),
            if (resultPath != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Kayıt Yeri:\n$resultPath"),
              ),
          ],
        ),
      ),
    );
  }
}
