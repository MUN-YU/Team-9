import 'package:flutter/material.dart';
import 'package:grand_market/2_mypage/Sales_list_screen.dart';
import 'package:grand_market/2_mypage/Transaction_list_screen.dart';
import 'package:grand_market/2_mypage/interest_list_screen.dart';

class Mypage_test extends StatefulWidget {
  const Mypage_test({super.key});

  @override
  _Mypage_testState createState() => _Mypage_testState();
}

class _Mypage_testState extends State<Mypage_test> {
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
          ],
        ),
      ),
    );
  }
}
