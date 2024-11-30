import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  VerifyState createState() => VerifyState();
}

class VerifyState extends State<Verify> {
  // TextEditingController를 통해 입력값을 관리
  final TextEditingController _textController = TextEditingController();
  String _displayText = "";

  // 입력값 확인 버튼을 눌렀을 때 동작
  void _showInputText() {
    setState(() {
      _displayText = _textController.text;
    });
  }

  @override
  void dispose() {
    // TextEditingController 메모리 해제
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("입력창 예제"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 텍스트 입력창
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "인증코드 입력",
                hintText: "여기에 입력하세요",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // 입력값 확인 버튼
            ElevatedButton(
              onPressed: _showInputText,
              child: const Text("입력값 확인"),
            ),
            const SizedBox(height: 20),
            // 입력값 표시
            Text(
              _displayText.isEmpty ? "아직 입력된 값이 없습니다." : "입력된 값: $_displayText",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
