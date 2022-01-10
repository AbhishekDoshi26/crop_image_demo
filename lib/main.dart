import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = CropController();
  Uint8List? bytes;
  Uint8List? _newImage;
  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() async {
    bytes = (await NetworkAssetBundle(Uri.parse(
                "https://i.pinimg.com/736x/3c/02/c0/3c02c07c231fd281808c734e26a6aacb.jpg"))
            .load(
                "https://i.pinimg.com/736x/3c/02/c0/3c02c07c231fd281808c734e26a6aacb.jpg"))
        .buffer
        .asUint8List();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.crop(),
      ),
      body: bytes == null
          ? const Center(child: CircularProgressIndicator())
          : _newImage == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Crop(
                    image: bytes!,
                    controller: _controller,
                    onCropped: (image) {
                      setState(() {
                        _newImage = image;
                      });
                    },
                  ),
                )
              : Image(image: MemoryImage(_newImage!)),
    );
  }
}
