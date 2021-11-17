import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/screen/home/home_screen.dart';
import 'package:flutter_lovers/src/screen/signIn/sign_in_screen.dart';
import 'package:flutter_lovers/src/viewmodel/user/user_viewmodel.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    var _userViewModel = Provider.of<UserViewModel>(context);

    /*Consumer<UserViewModel>(
      builder: (context, user, child) {
        if (user != null) {
          return HomeScreen();
        } else {
          return SignInScreen();
        }
      },
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );*/

   if (_userViewModel.viewState == ViewState.Idle) {
      return SignInScreen();
    } else if (_userViewModel.viewState == ViewState.Busy) {
      return HomeScreen();
    } else {
      return Scaffold(
        body: Center(
          child: SignInScreen(),
        ),
      );
    }
  }

/*  Future<UserModel> currentUser(BuildContext context) async {
    try{
      final _userViewModel = await Provider.of<UserViewModel>(context);
      Future<UserModel?> _user = _userViewModel.currentUser();
      if (_user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
    }catch(e){
      throw Exception('LandingScreen currentUser error : ' + e.toString());
    }
  }*/
}
