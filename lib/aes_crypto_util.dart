import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class AesCryptoUtil {

  AesCryptoUtil._(); // Private constructor

  static const int _ivLength = 12; // 96 bits
  static const int _tagLength = 16; // 128 bits in bytes

  /// Encrypts [data] with base64-encoded [key] and [iv]. Returns base64(IV + ciphertext + tag)
  static String encrypt(String data, String base64Key, String base64Iv) {

    final key = base64Decode(base64Key);
    final iv = base64Decode(base64Iv);
    final plainText = utf8.encode(data);

    final cipher = GCMBlockCipher(AESEngine())..init(
        true, // true=encrypt
        AEADParameters(
          KeyParameter(key),
          _tagLength * 8, // in bits
          iv,
          Uint8List(0), // optional AAD (empty)
        ),
      );

    final cipherTextWithTag = cipher.process(Uint8List.fromList(plainText));

    // Output format: IV + CipherText + Tag
    final output = Uint8List(iv.length + cipherTextWithTag.length);
    output.setRange(0, iv.length, iv);
    output.setRange(iv.length, output.length, cipherTextWithTag);

    return base64Encode(output);
  }

  /// Decrypts base64(IV + ciphertext + tag) using base64 [key] and [iv]
  static String decrypt(String base64Data, String base64Key, String base64Iv) {

    final key = base64Decode(base64Key);
    final iv = base64Decode(base64Iv);
    final input = base64Decode(base64Data);

    // Split IV and cipherText+tag
    final cipherTextWithTag = input.sublist(iv.length); // skip IV

    final cipher = GCMBlockCipher(AESEngine())..init(
        false, // false=decrypt
        AEADParameters(
          KeyParameter(key),
          _tagLength * 8, // in bits
          iv,
          Uint8List(0),
        ),
      );

    final plainText = cipher.process(cipherTextWithTag);
    return utf8.decode(plainText);
  }
}
