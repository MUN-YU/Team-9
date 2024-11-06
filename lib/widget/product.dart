import 'package:flutter/material.dart';
import 'package:grand_market/2_mypage/Review_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product extends StatefulWidget {
  final Function(int) delete;

  final int type;
  final int product_id;
  final String image_link;
  final String title;
  final String text;
  final String price;

  // 생성자에서 text를 받음
  const Product({
    Key? key,
    required this.type,
    required this.product_id,
    required this.image_link,
    required this.title,
    required this.text,
    required this.price,
    required this.delete,
  }) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class HeartButton extends StatefulWidget {
  final bool isliked;
  final int itemIdx;

  const HeartButton({
    Key? key,
    required this.isliked,
    required this.itemIdx,
  }) : super(key: key);

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class Rem_ModButton extends StatefulWidget {
  final Function() onpressed;

  const Rem_ModButton({required this.onpressed, Key? key}) : super(key: key);

  _Rem_ModButtonState createState() => _Rem_ModButtonState();
}

class ReviewButton extends StatefulWidget {
  final int itemIdx;

  const ReviewButton({Key? key, required this.itemIdx}) : super(key: key);

  _ReviewButtonState createState() => _ReviewButtonState();
}



class _ProductState extends State<Product> {
  late int _type;
  late int _product_id;
  late String _image_link;
  late String _title;
  late String _text;
  late String _price;

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    _product_id = widget.product_id;
    _image_link = widget.image_link;
    _title = widget.title;
    _text = widget.text;
    _price = widget.price;
  }

  void _delete(){
    widget.delete(_product_id);
  }

  @override
  Widget build(BuildContext context) {
    Widget dynamicwidget;

    switch(_type){
      case 0:
        dynamicwidget=HeartButton(isliked: false, itemIdx: _product_id,);
        break;
      case 1:
        dynamicwidget=HeartButton(isliked: true, itemIdx: _product_id);
        break;
      case 2:
        dynamicwidget=Rem_ModButton(onpressed: _delete);
        break;
      case 3:
        dynamicwidget=ReviewButton(itemIdx: widget.product_id,);
        break;
      default:
        dynamicwidget=Text('error');
        break;
    }

    return 
        GestureDetector(
          onTap: () {
            print("click!!");  //->제품 상세 목록으로 이동
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(5.0), 
              ),
              width: MediaQuery.of(context).size.width*0.95,
              height: 130.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  //Padding(
                    //padding: EdgeInsets.all(5),
                    //child: 
                  Expanded(
                    flex:2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 120,
                      height: 120,
                      child: Image.network(
                        _image_link, 
                        fit: BoxFit.contain,
                        ),
                    ),
                  ),
                  //),
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
                              _title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16.0,  // 텍스트 크기
                                fontWeight: FontWeight.bold,  // 폰트 두께
                              ),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Text(
                              _text,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: Text(
                              _price,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16.0,  // 텍스트 크기
                              ),
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                  Expanded(
                    flex:1,
                    child: dynamicwidget,
                  ),
                ]
              ),
            ),
          ),
        );
  }
}

class _HeartButtonState extends State<HeartButton> {
  bool _isLiked = false;

  void initState() {
    super.initState();
    _isLiked=widget.isliked;
  }

  Future<void> togglelikes(int itemIdx) async {
    final url = Uri.parse('https://swe9.comit-server.com/items/likes');

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "itemIdx": itemIdx
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data received: $data');

        if (data['status'] == 200) {
          setState(() {
              _isLiked = !_isLiked; // 하트 상태를 반전시킴
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

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border, // 하트 상태에 따라 아이콘 변경
            color: _isLiked ? Colors.red : Colors.grey, // 색상 변경
            size: 50, // 아이콘 크기
          ),
          onPressed: () {
            togglelikes(widget.itemIdx);
          },
        ),
      );
  }
}

class _Rem_ModButtonState extends State<Rem_ModButton>{
  void _onpressed(){
    widget.onpressed();
  }

 Widget build(BuildContext context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        padding: const EdgeInsets.all(5),
        child: TextButton(
          onPressed: _onpressed,
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero), // 모서리를 각지게 설정
            ),
            backgroundColor: Colors.grey,
          ),
          child: const Text(
            "삭제",
            style: TextStyle(
              fontSize: 16.0, 
              color: Colors.black,
            ),
          )
        ),
      ),
      Container(
        padding: const EdgeInsets.all(5),
        child: TextButton(
          onPressed: (){print("modity");},  //수정 화면으로 넘어가야함 //물품 등록 페이지에서 하단 버튼만 수정하기로 변경
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero), // 모서리를 각지게 설정
            ),
            backgroundColor: Colors.grey,
          ),
          child: const Text(
            "수정",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,  // 텍스트 크기
            ),
          )
        ),
      ),
  ],);
 } 
}

class _ReviewButtonState extends State<ReviewButton>{
 Widget build(BuildContext context){
  return Container(
    padding: EdgeInsets.all(5),
    child: TextButton(
      onPressed: (){Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReviewPage(itemIdx: widget.itemIdx,)));
        },
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero), // 모서리를 각지게 설정
        ),
        backgroundColor: Colors.grey,
      ),
      child: const Text(
        "리뷰\n남기기",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.black,  // 텍스트 크기
        ),
      )
    )
  );
}
}