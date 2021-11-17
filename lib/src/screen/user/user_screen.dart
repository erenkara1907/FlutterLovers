import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/screen/user/user_detail_example.dart';
import 'package:flutter_lovers/src/viewmodel/user/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _userViewModel.getAllUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcılar'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserDetailExample()));
            },
            icon: const Icon(Icons.gamepad_outlined),
          ),
        ],
      ),
      body: Consumer<UserViewModel>(builder: (context, user, child) {
        return FutureBuilder<List<UserModel>>(
          future: user.getAllUser(),
          builder: (context, result) {
            if (result.hasData) {
              var allUser = result.data;
              if (allUser!.length -1 > 0) {
                return ListView.builder(
                  itemCount: allUser.length,
                  itemBuilder: (context, index) {
                    var user = result.data![index];
                    if(user.userID != _userViewModel.userModel!.userID){
                      return ListTile(
                        title: Text(user.userName!),
                        subtitle: Text(user.email!),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl!),
                        ),
                      );
                    }else {
                      return Container();
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text('Kayıtlı bir kullanıcı bulunamadı'),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }
}
