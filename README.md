# 🔐 Crypto Tool (Flutter)

A simple Flutter app for generating SHA-256 signatures and encrypting data using AES-GCM.

Includes a clean UI with:
- ✅ Multi-line expandable input field
- ✅ Buttons to generate signature and encrypt data
- ✅ Display of signature, encrypted, and decrypted data

---

## ✨ Features

- AES-GCM encryption/decryption (256-bit key)
- SHA-256 signature generation
- Base64 + URL encoding
- Responsive Flutter UI

---

## 🧱 Tech Used

- Flutter
- `pointycastle` for AES-GCM encryption
- `crypto` for SHA-256 hashing
- `dart:convert` for encoding

---

## 🏁 Getting Started

1. **Clone the repository**
2. **Add your secrets** in a file called `app_secrets.dart`:
   ```dart
   class AppSecrets {
     static const clientId = 'your-client-id';
     static const clientSecret = 'your-client-secret';
     static const aesKey = 'base64-encoded-256-bit-key';
     static const aesIV = 'base64-encoded-12-byte-iv';
   }
