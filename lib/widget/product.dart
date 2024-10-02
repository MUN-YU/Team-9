import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  final String text;

  // 생성자에서 text를 받음
  const Product({super.key, required this.text});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return 
        GestureDetector(
          onTap: () {
            print(_text);
          },
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              width: MediaQuery.of(context).size.width*0.95,
              height: 100.0,
              child: Row(),
            ),
          ),
        );
  }
}
