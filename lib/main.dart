import 'dart:async';
import 'dart:convert';

import 'package:crypto_currences/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void  main() async {
  _testSignInWithGoogle;
  List currencies = await getCurrences();
  print(currencies);
  runApp(new MyApp(currencies: currencies,));
}

Future<String> _testSignInWithGoogle() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth =
  await googleUser.authentication;
  final FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  assert(user.email != null);
  assert(user.displayName != null);
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

class MyApp extends StatelessWidget {
  final List currencies;
  MyApp({this.currencies});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: defaultTargetPlatform == TargetPlatform.iOS? Colors.grey: Colors.pink),
      home: new HomePage(currencies: currencies,),
    );
  }
}

Future<List> getCurrences() async {
  String cryptoUrl = "https://api.coinmarketcap.com/v1/ticker/?limit=100";
  http.Response response = await http.get(cryptoUrl);
  return JSON.decode(response.body);
}




