import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_search_app/data/dto/ImageResult.dart';
import 'package:image_search_app/data/model/photo.dart';

class ImageRepository {
  Future<List<Photo>> fetchImages(String query) async {
    // 안에서 await을 안 걸어줬기 때문에 너무 빨리 넘어가서 안됐음. 다른 스레드에서 실행되니까? (내 추측)
    // await Future.delayed(Duration(seconds: 2)); // 2초 있다가 바꿔줌
    // api key는 알아서 얻자ㅎㅎ;;
    var key = 'something';
    var response = await http.get(Uri.parse('https://pixabay.com/api/?key=$key&q=$query&image_type=photo'));

    // dynamic은 다른 타입을 할당해줄 수 있기 때문에 아주 조심히 써야된다.
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final imageResult = ImageResult.fromJson(json);

    if (imageResult.hits == null) {
      return [];
    }

    return imageResult.hits!
        .where((e) => e.webformatURL != null)
        .map((e) => Photo(e.webformatURL!, e.tags ?? '정보 없음',))
        .toList();
  }
}
