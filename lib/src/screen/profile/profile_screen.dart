import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/common_widget/%20platform_responsive_widget/responsive_alert_dialog/responsive_alert_dialog.dart';
import 'package:flutter_lovers/src/common_widget/social_button/social_button.dart';
import 'package:flutter_lovers/src/screen/profile/style/button.style.dart';
import 'package:flutter_lovers/src/screen/signIn/sign_in_screen.dart';
import 'package:flutter_lovers/src/viewmodel/user/user_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? _usernameController;
  final ImagePicker _picker = ImagePicker();
  XFile? _profilePhoto;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _acceptForExit(context);
              },
              child: const Text(
                'Çıkış',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<UserViewModel>(
              builder: (context, user, child) {
                _usernameController!.text = user.userModel!.userName!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera),
                                      title: const Text('Kameradan Çek'),
                                      onTap: () {
                                        _takePhotoFromCamera(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.image),
                                      title: const Text('Galeriden Seç'),
                                      onTap: () {
                                        _selectPhotoFromGallery(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.transparent,
                            backgroundImage: _profilePhoto == null
                                ? NetworkImage(user.userModel!.photoUrl!)
                                : FileImage(File(_profilePhoto!.path))
                                    as ImageProvider),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: user.userModel!.email!,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Kullanıcı Adı',
                          hintText: 'Kullanıcı Adı',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: SocialLoginButtonComponent(
                        style: profileButtonStyle,
                        text: ' Değişiklikleri kaydet',
                        function: () {
                          _updateUsername(context);
                          _updateProfilePhoto(context);
                        },
                        textColor: Colors.white,
                        icon: const FaIcon(FontAwesomeIcons.save),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }

  Future<bool> _logOut(BuildContext context) async {
    try {
      final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
      bool? result = await _userViewModel.signOut();
      if (result == true) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        throw Exception('ProfileScreen _logOut Navigate error : ');
      }
      return result!;
    } catch (e) {
      throw Exception('ProfileScreen _logOut error : ' + e.toString());
    }
  }

  Future _acceptForExit(BuildContext context) async {
    final result = await ResponsiveAlertDialog(
      title: 'Emin misiniz?',
      content: 'Çıkmak istediğinizden emin misiniz?',
      baseButtonText: 'Evet',
      backButtonText: 'Vazgeç',
    ).show(context);

    if (result == true) {
      await _logOut(context);
    }
  }

  void _updateUsername(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userViewModel.userModel!.userName != _usernameController!.text) {
      var updateResult = await _userViewModel.updateUsername(
          _userViewModel.userModel!.userID!, _usernameController!.text);

      if (updateResult == true) {
        ResponsiveAlertDialog(
          title: 'Başarılı',
          content: 'Kullanıcı adınız başarıyla değiştirildi',
          baseButtonText: 'Tamam',
        ).show(context);
      } else {
        _usernameController!.text = _userViewModel.userModel!.userName!;
        ResponsiveAlertDialog(
          title: 'Hata',
          content:
              'Kullanıcı adı kullanımda, farklı bir kullanıcı adı deneyiniz',
          baseButtonText: 'Tamam',
        ).show(context);
      }
    }
  }

  void _takePhotoFromCamera(BuildContext context) async {
    var _newPhoto = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _profilePhoto = _newPhoto;
      Navigator.of(context).pop();
    });
  }

  void _selectPhotoFromGallery(BuildContext context) async {
    var _newPhoto = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePhoto = _newPhoto;
      Navigator.of(context).pop();
    });
  }

  void _updateProfilePhoto(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_profilePhoto != null) {
      var url = await _userViewModel.uploadFile(
          _userViewModel.userModel!.userID,
          'profile_photo',
          File(_profilePhoto!.path));

      if (url != null) {
        ResponsiveAlertDialog(
          title: 'Başarılı',
          content: 'Profil fotoğrafınız başarıyla güncellendi',
          baseButtonText: 'Tamam',
        ).show(context);
      }
    }
  }
}
