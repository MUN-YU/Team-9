import 'dart:math';

class EmailVerificationService {
  String _generatedCode = '';

  String generateVerificationCode() {
    final random = Random();
    _generatedCode = List.generate(6, (_) => random.nextInt(10)).join();
    return _generatedCode;
  }

  bool verifyCode(String userInputCode) {
    return userInputCode == _generatedCode;
  }
}
