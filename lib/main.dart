import 'package:flutter/material.dart';
import 'package:image_search_app/data/repository/image_repository.dart';
import 'package:image_search_app/ui/main/main_screen.dart';
import 'package:image_search_app/ui/main/main_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      // 상태 관리 라이브러리를 통해 MainViewModel이라는 객체를 만들어서 언제든 의존성 주입을 하겠다.
      create: (_) => MainViewModel(ImageRepository()),
      child: MyApp()));
}

// stless는 변수를 가질 수 없다. stlful하게 자동으로 만들어주면 된다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // black은 안된다. material 디자인은 블랙을 못하도록 해놓음
        primarySwatch: Colors.green,
      ),
      home: MainScreen(), // 사실은 new가 다 있는 것
    );
  }
}

// 상태 없는 것으로 항상 만든다. 필요할 때 상태가 있는 것으로 컨버팅하면 된다. stless로 만들기
