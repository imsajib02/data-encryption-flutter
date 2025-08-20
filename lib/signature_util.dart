import 'dart:convert';

import 'package:crypto/crypto.dart';

class SignatureUtil {

  SignatureUtil._();

  static String generateSignature({required String transactionId, required String clientId, required String timestamp,
    required String rawData, required String clientSecret}) {

    final payload = transactionId + clientId + timestamp + rawData + clientSecret;
    final bytes = utf8.encode(payload);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}