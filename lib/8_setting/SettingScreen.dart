import 'package:flutter/material.dart';
import 'package:grand_market/0_screens/1_login/login_screen.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              '사용자 설정',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('계정 / 정보 관리'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountManagementScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              '기타',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('언어 설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('버전 정보'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VersionInfoScreen()),
              );
            },
          ),
          ListTile(
            title: Text('로그아웃'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AccountManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('계정 / 정보 관리')),
      body: Center(child: Text('계정 / 정보 관리 페이지')),
    );
  }
}

class LanguageSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('언어 설정')),
      body: Center(child: Text('언어 설정 페이지')),
    );
  }
}

class VersionInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('버전 정보')),
      body: Center(child: Text('버전 정보 페이지')),
    );
  }
}

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그아웃')),
      body: Center(child: Text('로그아웃 페이지')),
    );
  }
}
