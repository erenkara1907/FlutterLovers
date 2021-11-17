import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lovers/src/common_widget/%20platform_responsive_widget/responsive_alert_dialog/responsive_alert_dialog.dart';
import 'package:flutter_lovers/src/errors/email_password_login/error_exception.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/screen/home/home_screen.dart';
import 'package:flutter_lovers/src/common_widget/social_button/social_button.dart';
import 'package:flutter_lovers/src/common_widget/social_button/style/social_button.style.dart';
import 'package:flutter_lovers/src/viewmodel/user/user_viewmodel.dart';
import 'package:provider/provider.dart';

enum FormType { Register, Login }

class EmailPasswordSignScreen extends StatefulWidget {
  @override
  _EmailPasswordSignScreenState createState() =>
      _EmailPasswordSignScreenState();
}

class _EmailPasswordSignScreenState extends State<EmailPasswordSignScreen> {
  String? _buttonText, _linkText;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  var _formType = FormType.Login;

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.Login ? 'Giriş Yap' : 'Kayıt Ol';
    _linkText = _formType == FormType.Login
        ? 'Hesabınız Yok Mu? Kayıt Olun'
        : 'Hesabınız Var Mı? Giriş Yapın';

    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş / Kayıt'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: _email,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Parola',
                  labelText: 'Parola',
                  border: OutlineInputBorder(),
                ),
                controller: _password,
              ),
              const SizedBox(
                height: 10,
              ),
              SocialLoginButtonComponent(
                style: loginStyle,
                text: ' $_buttonText',
                function: () {
                  _formSubmit();
                },
                textColor: Colors.white,
                icon: const Icon(Icons.forward),
              ),
              TextButton(
                onPressed: () => _changeForm(),
                child: Text('$_linkText'),
              ),
            ],
          )),
        ),
      ),
    );
  }

  void _formSubmit() async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_formType == FormType.Login) {
      try {
        UserModel? _login = await _userViewModel.signInWithEmailAndPassword(
            _email.text, _password.text);
        if (_login != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          throw Exception('Başarısız Giriş..');
        }
      } on FirebaseAuthException catch (e) {
        ResponsiveAlertDialog(
          title: 'Kullanıcı Girişi HATA!',
          content: Errors.show(e.code)!,
          baseButtonText: 'Tamam',
        ).show(context);
      }
    } else {
      try {
        UserModel? _create = await _userViewModel
            .createUserWithEmailAndPassword(_email.text, _password.text);
        if (_create != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          throw Exception('Başarısız Kayıt..');
        }
      } on FirebaseAuthException catch (e) {
        ResponsiveAlertDialog(
          title: 'Kullanıcı Oluşturma HATA!',
          content: Errors.show(e.code)!,
          baseButtonText: 'Tamam',
        ).show(context);
      }
    }
  }

  void _changeForm() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }
}
