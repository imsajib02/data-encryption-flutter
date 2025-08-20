import 'dart:convert';

import 'package:flutter/material.dart';

import 'aes_crypto_util.dart';
import 'app_secrets.dart';
import 'signature_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  final Color _primaryColor = Colors.deepPurple;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      home: CryptoScreen(),
    );
  }
}

class CryptoScreen extends StatefulWidget {

  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {

  final _inputController = TextEditingController();

  int _index = 0;

  String _signature = '', _encryptedData = '', _decryptedData = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Tool'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: _inputController,
                keyboardType: TextInputType.multiline,
                maxLines: null, // allow expansion
                minLines: 4,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter data here',
                  alignLabelWithHint: true,
                ),
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Expanded(
                    child: ElevatedButton(
                      onPressed: _getSignature,
                      child: Text('Gen. Signature'),
                    ),
                  ),

                  SizedBox(width: 15,),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: _performEncryption,
                      child: Text('Encrypt Data'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 80),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IndexedStack(
                    index: _index,
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text('Signature',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
                          ),

                          SizedBox(height: 15,),

                          Text(_signature,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text('Encrypted Data',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
                          ),

                          SizedBox(height: 15,),

                          Text(_encryptedData,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),

                          SizedBox(height: 40,),

                          Text('Decrypted Data',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
                          ),

                          SizedBox(height: 15,),

                          Text(_decryptedData,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getSignature() {

    var rawData = {
      "app": 'Crypto Tool',
      "input": _inputController.text,
    };

    final result = SignatureUtil.generateSignature(
      transactionId: 'CHA8MqKza9BaL23',
      clientId: AppSecrets.clientId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      rawData: json.encode(rawData),
      clientSecret: AppSecrets.clientSecret,
    );

    print('\n\nSignature: $result');

    setState(() {
      _signature = result;
      _index = 0;
    });
  }

  void _performEncryption() {

    var rawData = {
      "app": 'Crypto Tool',
      "input": _inputController.text,
    };

    final encryptedData = AesCryptoUtil.encrypt(json.encode(rawData), AppSecrets.aesKey, AppSecrets.aesIV);
    print('\n\nEncrypted (Base64): $encryptedData');

    // URL encode for HTTP param
    final urlEncoded = Uri.encodeComponent(encryptedData);
    print('URL Encoded: $urlEncoded');

    String decryptedData = AesCryptoUtil.decrypt(encryptedData, AppSecrets.aesKey, AppSecrets.aesIV);
    print('Decrypted Data: $decryptedData');

    setState(() {
      _encryptedData = encryptedData;
      _decryptedData = decryptedData;
      _index = 1;
    });
  }
}
