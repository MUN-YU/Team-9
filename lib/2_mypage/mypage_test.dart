import 'package:flutter/material.dart';
import 'package:grand_market/2_mypage/Sales_list_screen.dart';
import 'package:grand_market/2_mypage/Transaction_list_screen.dart';
import 'package:grand_market/2_mypage/interest_list_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mypage_test extends StatefulWidget {
  const Mypage_test({super.key});

  @override
  _Mypage_testState createState() => _Mypage_testState();
}

class _Mypage_testState extends State<Mypage_test> {
  late String _token;
  //임시 회원가입
  Future<void> Regist() async {
    final url = Uri.parse('https://swe9.comit-server.com/api/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
      },
        body: jsonEncode({
          "name": "testname",
          "id": "testid",
          "password": "12345678",
          "major": "소프트웨어학과",
          "email": "test@g.skku.edu",
          "isValid": true,
        }),
      );

    if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data received: $data');
    } else {
        print('Failed to load data: ${response.statusCode} ${response.body}');
    }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
  //임시로 토큰 받는 함수
  Future<void> getToken() async {
    final url = Uri.parse('https://swe9.comit-server.com/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",},
        body: jsonEncode({
          "id": "testid",
          "password": "12345678",
        }),
      );

    if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data received: $data');

        _token = data['content']['token'];
        print('Token: $_token');
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
        backgroundColor: const Color.fromARGB(255, 20, 37, 26),
        title: const Text(
          "마이페이지",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex:1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 222, 211, 27)),
                onPressed: (){Navigator.push(
                  context, MaterialPageRoute(builder: (context) => InterestListScreen()));
                  },
                child: const Text(
                  "관심목록",
                  style: TextStyle(
                      color: Color.fromARGB(255, 20, 37, 26)),
                ),
              ),
            ),
            const Spacer(flex:1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 222, 211, 27)),
                onPressed: (){Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SalesListScreen()));
                  },
                child: const Text(
                  "판매목록",
                  style: TextStyle(
                      color: Color.fromARGB(255, 20, 37, 26)),
                ),
              ),
            ),
            const Spacer(flex:1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 222, 211, 27)),
                onPressed: (){Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TransactionListScreen()));
                  },
                child: const Text(
                  "거래목록",
                  style: TextStyle(
                      color: Color.fromARGB(255, 20, 37, 26)),
                ),
              ),
            ),
            const Spacer(flex:1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 222, 211, 27)),
                onPressed: (){
                  Regist();
                  getToken();
                  },
                child: const Text(
                  "임시 토큰",
                  style: TextStyle(
                      color: Color.fromARGB(255, 20, 37, 26)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
