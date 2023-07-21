import 'package:flutter/material.dart';

class FileViewer extends StatelessWidget {
  final List<String> fileNames = [
    "Sample Document.pdf",
    "Image.jpg",
    "Video.mp4",
  ];

  void _downloadFile(String fileName) {
    // Replace this callback with your actual file download logic
    print("Downloading $fileName...");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.file_download),
      title: Text(fileNames[0]),
      onTap: () => _downloadFile(fileNames[0]),
    );
  }
}
