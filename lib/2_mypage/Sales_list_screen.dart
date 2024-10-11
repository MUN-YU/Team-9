import 'package:flutter/material.dart';
import '../widget/product.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  late List<int> _products_list=[1,2,3,4,5,6,7,8,9,10];

  @override
  void initState(){
    super.initState();
  }

  void _updatepage(int product_id) {
    setState(() {
      print("Deleting product with ID: $product_id");
      _products_list.removeWhere((item) => item == product_id);
      print("Updated list: $_products_list");
    });
  }

  //future() //백엔드에서 정보 불러오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },    //뒤로가기 버튼 구현하기(pop기능)
        ),
        title: const Text(
          "관심 목록",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(//children: createWidgetList(),)
          children: _products_list.map((product_id) {
            print(product_id);
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Product(
                type: 2,
                product_id: product_id,
                image_link:
                    'http://github.com/MUN-YU/Team-9/blob/gwangbin/assets/images/test.png?raw=true',
                title: '일반 화학 8판',
                text: '@@강의 @@교수님',
                price: '${15000}원',
                delete: _updatepage,
              ),
            );
          }).toList(),
        )
      )
    );
  }
}
