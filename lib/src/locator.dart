import 'package:flutter_lovers/src/repository/user/user_repository.dart';
import 'package:flutter_lovers/src/service/firebase_service/database/firestore/db_service.dart';
import 'package:flutter_lovers/src/service/firebase_service/storage/firebase/storage_service.dart';
import 'package:get_it/get_it.dart';
import 'service/firebase_service/auth/auth_service.dart';
import 'service/firebase_service/auth/fake_auth_service.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator(){
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => DbService());
  locator.registerLazySingleton(() => StorageService());
}