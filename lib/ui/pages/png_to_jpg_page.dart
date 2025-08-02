import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class PngToJpgPage extends StatefulWidget {
  const PngToJpgPage({super.key});

  @override
  State<PngToJpgPage> createState() => _PngToJpgPageState();
}

class _PngToJpgPageState extends State<PngToJpgPage> {
  String? resultPath;

  Future<void> convertPngToJpg() async {
    // Kullanıcıdan PNG dosyası seçmesini iste
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
    );

    if (result == null || result.files.single.path == null) return;

    final inputFile = File(result.files.single.path!);
    final bytes = await inputFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Görsel çözümlenemedi.")),
      );
      return;
    }

    final jpgBytes = img.encodeJpg(image);

    // Kullanıcıdan hedef klasör seçmesini iste
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      // Kullanıcı iptal etti
      return;
    }

    final fileName = 'converted_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outputPath = '$directoryPath/$fileName';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(jpgBytes);

    setState(() {
      resultPath = outputPath;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("JPG dosyası başarıyla kaydedildi:\n$outputPath")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PNG to JPG")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: convertPngToJpg,
              child: const Text("PNG Dosyası Seç ve JPG'ye Dönüştür"),
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
