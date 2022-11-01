import 'package:flutter/material.dart';
import 'package:image_search_app/data/model/photo.dart';

class DetailScreen extends StatelessWidget {
  final Photo photo;

  const DetailScreen({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 새로운 화면에도 appbar가 필요하면 Scaffold를 만든다.
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Hero(
            tag: photo.url,
            child: Image.network(
              photo.url,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Text(photo.desc),
        ],
      ),
    );
  }
}
