import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/screen/user/user_detail_example_not_bottombar.dart';

class UserDetailExample extends StatelessWidget {
  const UserDetailExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const UserDetailExampleNotBottomBar(),
                ),
              );
            },
            icon: const Icon(Icons.adb),
          )
        ],
        title: const Text('User Detail Example Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('User Detail Example Page Body'),
      ),
    );
  }
}
