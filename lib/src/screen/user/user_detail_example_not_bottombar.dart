import 'package:flutter/material.dart';

class UserDetailExampleNotBottomBar extends StatelessWidget {
  const UserDetailExampleNotBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail Example Not Bottom Bar'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('User Detail Example Not Bottom Bar'),
      ),
    );
  }
}
