import 'package:flutter/material.dart';
import '../widget/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterestListScreen extends StatefulWidget {
  const InterestListScreen({super.key});

  @override
  _InterestListScreenState createState() => _InterestListScreenState();
}

class _InterestListScreenState extends State<InterestListScreen> {
  List<dynamic> _products = [];

  @override
  void initState(){
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://swe9.comit-server.com/mypage/likes');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data received: $data');

        if (data['status'] == 200) {
          setState(() {
            _products = data['content']; // 가져온 제품 데이터를 저장
          });
        } else {
          // 오류 처리
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load data: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

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
          children: _products.map((product) {
            return Padding(
                padding: const EdgeInsets.all(5),
                child: Product(
                  type: 1,
                  product_id: product['itemIdx'],
                  image_link: product['itemImage'], 
                  title: product['title'], 
                  text: product['description'],
                  price: '${product['price']}원',
                  delete: (dynamic value) {},
                )
              );
          }).toList(),
        )
      )
    );
  }
}
