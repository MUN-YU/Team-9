import 'package:flutter/material.dart';
import '../widget/product.dart';

class InterestListScreen extends StatefulWidget {
  const InterestListScreen({super.key});

  @override
  _InterestListScreenState createState() => _InterestListScreenState();
}

class _InterestListScreenState extends State<InterestListScreen> {
  late List<int> _products_list=[1,2,3,4,5,6,7,8,9,10];

  @override
  void initState(){
    super.initState();
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
          children: List.generate(_products_list.length,(index){
            return Padding(
                padding: const EdgeInsets.all(5),
                child: Product(
                type: 1,
                product_id: _products_list[index],
                image_link: 'http://github.com/MUN-YU/Team-9/blob/gwangbin/assets/images/test.png?raw=true', 
                title: '일반 화학 8판', 
                text: '@@강의 @@교수님',
                price: 15000.toString()+'원',
                delete: (dynamic value) {},
                )
              );
          })
        )
      )
    );
  }
}
