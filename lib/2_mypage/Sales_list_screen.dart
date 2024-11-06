import 'package:flutter/material.dart';
import '../widget/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<dynamic> _products = [];
  late Map<int, bool> isvisible = {};

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void _updatepage(int product_id) {
    deleteProduct(product_id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://swe9.comit-server.com/mypage/selling');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        print("토큰이 없습니다.");
        return;
      }
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('Data received: $data');

        if (data['status'] == 200) {
          setState(() {
            _products = data['content']; // 가져온 제품 데이터를 저장

            for (dynamic product in _products) {
              isvisible[product['itemIdx']] = true;
            }
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

  Future<void> deleteProduct(int itemIdx) async {
    final url = Uri.parse(
        'https://swe9.comit-server.com/mypage/selling/' + itemIdx.toString());

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('Data received: $data');

        if (data['status'] == 200) {
          print('Succesfully delete');
          setState(() {
            //print("Deleting product with ID: $product_id");
            isvisible[itemIdx] = false;
            //print("Updated list: $_products_list");
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
            onPressed: () {
              Navigator.pop(context);
            }, //뒤로가기 버튼 구현하기(pop기능)
          ),
          title: const Text(
            "판매 목록",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          //children: createWidgetList(),)
          children: _products.map((product) {
            if (isvisible[product['itemIdx']] == true) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Product(
                  type: 2,
                  product_id: product['itemIdx'],
                  image_link: product['itemImage'],
                  title: product['title'],
                  text: product['description'],
                  price: '${product['price']}원',
                  delete: _updatepage,
                ),
              );
            } else {
              return const SizedBox();
            }
          }).toList(),
        )));
  }
}
