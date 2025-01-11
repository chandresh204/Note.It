import 'package:encrypt/encrypt.dart';

class EncDec {

  static const String keyStr = 'a12oaocf8547GwkAkis{k8TalXRaxI84';

  static String getEncryptedText(String text) {
    final key = Key.fromUtf8(keyStr);
  //  final iv = IV.fromLength(16);
    final iv = IV.allZerosOfLength(16);
    final encryptor = Encrypter(AES(key));
    final encrypted = encryptor.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String getDecryptText(String eString) {
    final encrypted = Encrypted.from64(eString);
    final key = Key.fromUtf8(keyStr);
  //  final iv = IV.fromLength(16);
    final iv = IV.allZerosOfLength(16);
    final encryptor = Encrypter(AES(key));
    final decrypted = encryptor.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}