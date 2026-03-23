import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../ulits/logger_ulits.dart';

part 'firebase_storage_service.g.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e, st) {
      LoggerUtils.firebaseError('FirebaseStorageService.uploadFile', e, st);
      rethrow;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e, st) {
      LoggerUtils.firebaseError('FirebaseStorageService.deleteFile', e, st);
      rethrow;
    }
  }

  Future<String> getDownloadUrl(String path) async {
    return await _storage.ref().child(path).getDownloadURL();
  }
}

@riverpod
FirebaseStorageService firebaseStorageService(Ref ref) {
  return FirebaseStorageService();
}
