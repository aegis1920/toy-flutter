import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_search_app/data/model/photo.dart';
import 'package:image_search_app/data/repository/image_repository.dart';
import 'package:image_search_app/ui/detail/detail_screen.dart';
import 'package:image_search_app/ui/main/components/image_item.dart';
import 'dart:developer';

import 'package:image_search_app/ui/main/main_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 알아서 타입 추론함
  // new가 빠져있어서 잘 모를 수 있으나 화면을 부를 때마다 인스턴스를 계속해서 부를 수 있게 된다.
  final viewModel = MainViewModel(ImageRepository());
  final queryTextController = TextEditingController();
  StreamSubscription<String>? subscription;

  @override
  void initState() {
    super.initState();

    // 원래는 context가 init할 때 없어서 안되지만, microtask 덕분에 찰나의 시간에 ViewModel을 initState에서도 접근할 수 있다.
    Future.microtask(() {
      // watch를 해주면 계속 지켜보겠다는 뜻
      final viewModel = context.read<MainViewModel>();
      // listen을 통해 스낵바가 뜨도록 할 수 있다.
      subscription = viewModel.eventStream.listen((message) {
        final snackBar = SnackBar(content: Text(message));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  // 뒤로가기 할 때 화면이 사라질 때
  @override
  void dispose() {
    // 이걸 해야 안전할 수 있다.
    queryTextController.dispose();
    // 스트림을 닫아줘야함
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 위젯 트리에서 MainViewModel을 찾음. 그리고 가져옴. 인스턴스 하나만 생성되어있는 상태에서 가지고오기만 하면 되기 떄문에 문제가 되지 않음
    final viewModel = context.watch<MainViewModel>();

    // 컨테이너는 백지장을 의미함 (기본이 블랙)
    // Scaffold는 material 디자인을 만들 때 기본적인 걸 만들어주는 얘
    return Scaffold(
      appBar: AppBar(
        // const는 compile time에 생성되는 상수. new를 하지 않아서 성능상 이점이 있다.
        title: Text('이미지 검색'),
      ),
      // 위에서 아래로 아이템을 배치함
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: queryTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    // print("안녕하세요");
                    // import 'dart:developer'; 이거 import 시켜줘야 함
                    log('로딩 시작!!');
                    // 상태가 바뀌면 다시 렌더링해줘야하니까 setState

                    // 비동기 코드라서 내가 원하는 타이밍에 갱신이 안됨. 그래서 onPressed를 비동기 함수로 바꿔야 함. async를 붙여주기
                    //
                    await viewModel.fetchImages(queryTextController.text);

                    // 얘는 화면을 렌더링 해라.
                    // setState(() {
                    //   viewModel.isLoading = false;
                    // });
                    log('로딩 끝!!');
                  },
                  icon: Icon(Icons.search),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Search',
                fillColor: Colors.white70,
              ),
            ),
          ),
          _buildList(viewModel),
          Text('안녕하세요!'),
          Text('Derrick입니다!'),
        ],
      ),
    );
  }

  Widget _buildList(MainViewModel viewModel) {
    // 컬럼과 리스트뷰의 차이는 컬럼은 데이터가 많으면 삐져나간다.
    // 스크롤이 나오는 게 리스트뷰를 하면 안 나오는 이유는 리스트의 사이즈가 없어서. Expend를 하면 사이즈만큼 확장하기 때문에 사이즈가 나와서 나오는 것
    return Expanded(
      // Center를 주면 로딩이 가운데로 이동. 이때 잘 줘야 한다. child쪽으로 wrapping을 잘 해줘야 한다.
      child: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.count(
              // Image.network()이름있는 생성자. Image객체를 만드는 방법 중 하나. 생성자다.
              // 함수형으로 그냥 만들어주면 됨
              crossAxisCount: 2,
              children: viewModel.items
                  .map((photo) => GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(photo: photo)));
                        },
                        child: ImageItem(url: photo.url),
                      ))
                  .toList(),
              // Text('hello~'),
              // Text('hello~'),
            ),
    );
  }
}
