import 'package:flutter/material.dart';
import '../domain/gif_model.dart';

class GifDetailScreen extends StatelessWidget {
  final GifModel gif;

  const GifDetailScreen({Key? key, required this.gif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(
          gif.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.redAccent),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              gif.fullSizeUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
