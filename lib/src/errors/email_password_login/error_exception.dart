class Errors {
  static String? show(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Bu mail adresi zaten mevcut, lütfen farklı bir mail kullanınız';

      case 'wrong-password' :
        return 'Yanlış kullanıcı adı veya parola girdiniz';

      case 'user-not-found' :
        return 'Kullanıcı bulunamadı';

      default:
        return 'Bir hata oluştu';
    }
  }
}
