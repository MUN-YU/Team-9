import 'package:flutter/material.dart';
import '../../widget/product.dart';

class InterestListScreen extends StatefulWidget {
  const InterestListScreen({super.key});

  @override
  _InterestListScreenState createState() => _InterestListScreenState();
}

class _InterestListScreenState extends State<InterestListScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isLoading = false; // 로딩 상태
  final int _num_products = 10;

  //future() //백엔드에서 정보 불러오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: const IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: null,    //뒤로가기 버튼 구현하기(pop기능)
        ),
        title: const Text(
          "관심 목록",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: createWidgetList(),)
      )
    );
  }

  List<Widget> createWidgetList() {
    List<Widget> widgetList = [];
    for (int i = 0; i < _num_products; i++) {
      widgetList.add(
        Padding(
          padding: const EdgeInsets.all(5),
          child: Product(text: "click")
        ),
      );
    }
    return widgetList;
  }
}
