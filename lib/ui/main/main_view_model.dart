import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_search_app/data/model/photo.dart';
import 'package:image_search_app/data/repository/image_repository.dart';

class MainViewModel extends ChangeNotifier {
  final ImageRepository repository;

  // 외부에서 마음껏 수정할 수 있기 때문에 위험한 코드. public 같은 접근제한자.
  List<Photo> items = [];
  bool isLoading = false;

  // 이 스트림은 스트림 데이터를 가질 수 있는 놈이다. 에러가 났을 때 UI쪽에서 받아서 처리해줄 수 있도록.
  final _eventController = StreamController<String>();

  // UI쪽에서는 eventStream을 통해 받는다. private만 하고 getter로 열어놓은 것
  Stream<String> get eventStream => _eventController.stream;

  MainViewModel(this.repository);

  // 비동기로 바꾸려면 Future를 붙여주기만 하면 된다
  // return 타입이 없으면 void, Future 타입은 async를 붙여줘야 한다.
  Future<void> fetchImages(String query) async {
    try {
      isLoading = true;

      // 여기서 로딩을 하게 됨
      notifyListeners();
      items = await repository.fetchImages(query);
    } catch (e) {
      _eventController.add('네트워크 에러!!');
    }
    isLoading = false;
    // 여기서 렌더링을 해줄 수 있도록 함
    notifyListeners();
  }
}
