import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  final int itemIdx;

  const ReviewPage({
    super.key,
    required this.itemIdx
  });

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double? _selectedReview;
  dynamic product={};

  final List<String> _items = [
    'A+ (4.5)',
    'A  (4.0)',
    'B+ (3.5)',
    'B  (3.0)',
    'C+ (2.5)',
    'C  (2.0)',
    'D+ (1.5)',
    'D  (1.0)',
    'D- (0.5)',
    'F  (0.0)',
  ];

  @override
  void initState(){
    super.initState();
    fetchProducts(widget.itemIdx);
  }

  Future<void> fetchProducts(int itemIdx) async {
    final url = Uri.parse('https://swe9.comit-server.com/mypage/rating?itemIdx='+itemIdx.toString());

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data received: $data');

        if (data['status'] == 200) {
          setState(() {
            product = data['content'];
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load data: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> postReview(int itemIdx, double rating) async {
    final url = Uri.parse('https://swe9.comit-server.com/mypage/rating');

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'itemIdx': itemIdx,
          'rating': rating,
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
          "거래 후기",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 왼쪽 정렬
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.95, // 가로 길이 최대로 설정
              height: 40.0, // 세로 길이 조절
              decoration: BoxDecoration(
                color: const Color(0xFFC4D5BA), // 배경색 설정
                borderRadius: BorderRadius.circular(8.0), 
              ),
              alignment: Alignment.center,
              child: const Text(
                "구매 물품",
                style: TextStyle(
                  fontSize: 20.0,  // 텍스트 크기
                  fontWeight: FontWeight.bold,  // 폰트 두께
                ),
              ),
            ),
            const SizedBox(height: 8.0), // 간격 추가
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(4.0), 
              ),
              width: MediaQuery.of(context).size.width*0.95,
              height: 160.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  Expanded(
                    flex:2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 150,
                      height: 150,
                      child: Image.network(
                        product['itemImage'],
                        fit: BoxFit.contain,
                        ),
                    ),
                  ),
                  Expanded(
                    flex:3,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex:1,
                            child: Text(
                              product['title'],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16.0,  // 텍스트 크기
                                fontWeight: FontWeight.bold,  // 폰트 두께
                              ),
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: Text(
                              product['description'],
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex:1,
                            child: Text(
                              product['transactionDate'],
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: Text(
                              product['price'].toString()+'원',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16.0, 
                              ),
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                ]
              ),
            ),
            const SizedBox(height: 10.0), // 간격 추가
            Container(
              width: MediaQuery.of(context).size.width*0.95, // 가로 길이 최대로 설정
              height: 40.0, // 세로 길이 조절
              decoration: BoxDecoration(
                color: const Color(0xFFC4D5BA), // 배경색 설정
                borderRadius: BorderRadius.circular(8.0), 
              ),
              alignment: Alignment.center,
              child: const Text(
                "판매자",
                style: TextStyle(
                  fontSize: 20.0,  // 텍스트 크기
                  fontWeight: FontWeight.bold,  // 폰트 두께
                ),
              ),
            ),
            const SizedBox(height: 8.0), // 간격 추가
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(4.0), 
              ),
              width: MediaQuery.of(context).size.width*0.95,
              height: 160.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  Container(
                    width: 160.0,
                    height: 160.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 110,
                        height: 110,
                        padding: const EdgeInsets.all(5),
                        child: ClipOval(
                          child: Image.asset(
                          "assets/images/profile.jpeg",
                          fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min, // Column의 크기를 자식의 크기에 맞추기
                        crossAxisAlignment: CrossAxisAlignment.start, // 자식들을 좌측 정렬
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 이름 부분
                          Container(
                            padding: const EdgeInsets.all(2),
                            color: const Color(0xFFC4D5BA),
                            //alignment: Alignment.centerLeft, // 텍스트 좌측 정렬
                            child: Text(
                              product['sellerName'],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16.0,  // 텍스트 크기
                                fontWeight: FontWeight.bold,  // 폰트 두께
                              ),
                            ),
                          ),
                          // 소속 대학 정보
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 180, // 최대 너비를 설정
                            ),
                            child: Text(
                              product['sellerMajor'],
                              softWrap: true, // 줄 바꿈 허용
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
            SizedBox(height: 10.0),
            Container(child:
            Row(children: [
              Container(
                width: 100, // 가로 길이 최대로 설정
                height: 40.0, // 세로 길이 조절
                decoration: BoxDecoration(
                  color: const Color(0xFFC4D5BA), // 배경색 설정
                  borderRadius: BorderRadius.circular(8.0), 
                ),
                alignment: Alignment.center,
                child: const Text(
                  "평점",
                  style: TextStyle(
                    fontSize: 20.0,  // 텍스트 크기
                    fontWeight: FontWeight.bold,  // 폰트 두께
                  ),
                ),
              ),
              SizedBox(width:8.0),
              Expanded(child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // 화면의 90% 가로 길이
              decoration: BoxDecoration(
                color: Colors.white, // 배경색을 흰색으로 설정
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // 그림자 색상
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // 그림자의 위치
                  ),
                ],
              ),
              child: DropdownButton<String>(
                hint: const Text('항목을 선택하세요'),
                value: _selectedReview != null ? '${_selectedReview!}' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedReview = double.parse(
                        newValue!.replaceAll(RegExp(r'[^0-9.]'), ''));
                  });
                },
                isExpanded: true,
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
            ],))
          ],
        ),
      ),   
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedReview != null) {
                postReview(widget.itemIdx, _selectedReview!);
              } else {
                print('Error: 평점이 선택되지 않았습니다.');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('평점을 선택해 주세요')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: const Color(0xFFC4D5BA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              "리뷰 남기기",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      )
    );
  }
}
