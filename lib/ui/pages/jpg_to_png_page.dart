import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class JpgToPngPage extends StatefulWidget {
  const JpgToPngPage({super.key});

  @override
  State<JpgToPngPage> createState() => _JpgToPngPageState();
}

class _JpgToPngPageState extends State<JpgToPngPage> {
  String? resultPath;

  Future<void> convertJpgToPng() async {
    // Kullanıcıdan JPG dosyası seçmesini iste
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
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

    final pngBytes = img.encodePng(image);

    // Kullanıcıdan hedef klasör seçmesini iste
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      // Kullanıcı iptal etti
      return;
    }

    final fileName = 'converted_${DateTime.now().millisecondsSinceEpoch}.png';
    final outputPath = '$directoryPath/$fileName';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pngBytes);

    setState(() {
      resultPath = outputPath;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PNG dosyası başarıyla kaydedildi:\n$outputPath")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JPG to PNG")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: convertJpgToPng,
              child: const Text("JPG Dosyası Seç ve PNG'ye Dönüştür"),
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
