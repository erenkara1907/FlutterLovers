import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/screen/home/home_screen.dart';
import 'package:flutter_lovers/src/screen/signIn/email_password/email_password_screen_sign.dart';
import 'package:flutter_lovers/src/viewmodel/user/user_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../common_widget/social_button/social_button.dart';
import '../../common_widget/social_button/style/social_button.style.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Lovers'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Oturum Açın',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SocialLoginButtonComponent(
              style: googleStyle,
              text: ' Google ile giriş yap',
              function: () async {
                await _loginWithGoogle(context);
              },
              textColor: Colors.black87,
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
            ),
            SocialLoginButtonComponent(
              style: facebookStyle,
              text: ' Facebook ile Giriş Yap',
              function: () => null,
              textColor: Colors.white,
              icon: const FaIcon(FontAwesomeIcons.facebook),
            ),
            SocialLoginButtonComponent(
              style: emailPasswordStyle,
              text: ' Email ve Parola ile Giriş Yap',
              function: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmailPasswordSignScreen()));
              },
              textColor: Colors.white,
              icon: const Icon(Icons.mail),
            ),
            SocialLoginButtonComponent(
              style: anonymousStyle,
              text: ' Misafir Girişi',
              function: () async {
                await _anonymousLogin(context);
              },
              textColor: Colors.white,
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _anonymousLogin(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInAnonymous();

    if (_user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      throw Exception('Başarısız Anonim Girişi');
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInWithGoogle();
    if (_user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      throw Exception('Başarısız Google Girişi');
    }
  }
}
