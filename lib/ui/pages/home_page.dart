import 'package:fileconverter/ui/pages/jpg_to_png_page.dart';
import 'package:fileconverter/ui/pages/pdf_to_word_page.dart';
import 'package:fileconverter/ui/pages/png_to_jpg_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  final List<_ConverterOption> options = [
    _ConverterOption("JPG to PNG", "assets/icons/jpg_to_png.svg"),
    _ConverterOption("PNG to JPG", "assets/icons/png_to_jpg.svg"),
    _ConverterOption("PDF to Word", "assets/icons/pdf_to_word.svg"),
    _ConverterOption("Word to PDF", "assets/icons/word_to_pdf.svg"),
    _ConverterOption("WebP to PNG", "assets/icons/webp_to_png.svg"),
    _ConverterOption("Merge PDFs", "assets/icons/merge_pdf.svg"),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dosya Dönüştürücü"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 sütun
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          return InkWell(
            onTap: () {
  switch (option.title) {
    case "JPG to PNG":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const JpgToPngPage()),
      );
      case "PNG to JPG":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PngToJpgPage()),
      );
      case "PDF to Word":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PdfToWordPage()),
      );
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${option.title} tıklandı")),
      );
  }
},

            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    option.iconPath,
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    option.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConverterOption {
  final String title;
  final String iconPath;

  _ConverterOption(this.title, this.iconPath);
}
