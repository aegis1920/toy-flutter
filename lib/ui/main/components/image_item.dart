import 'package:flutter/material.dart';

// 무조건 stateless로 나눔. 한 번 표시가 되면 변하지 않음. 이 화면을 렌더링하는 시점에서는 URL 셋팅이 되고 안 바뀜.
class ImageItem extends StatelessWidget {
  final String url;

  // 중괄호로 감싸져 있다면 named param. required면 필수
  const ImageItem({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(url,
              height: 300,
              // 꽉 채움
              fit: BoxFit.cover)),
    );
  }
}
