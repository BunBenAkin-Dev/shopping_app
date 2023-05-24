import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recap_shops/models/http_exceptions.dart';

class Auth with ChangeNotifier {
  late String? _token;
  DateTime? _expirydate = DateTime.now();
  late String _userId;

  bool get isAuth {
    //we are using the getter  to confirm the local  validation logic
    return token != null; //if token is not equal to null we are authenticated
    //if token return null , it shows that we dont have a valid token
    //if we have a token and token does not expire we are authenticated
  }

  String? get token {
    if (_expirydate !=
            null && //if expiry date is not null if it is null we cant have a valid token
        _expirydate!.isAfter(DateTime
            .now()) && //if expiry date isa after presnet datenow ot is valid
        _token != null) {
      //if token is not null then we return the token
      return _token;
    }
    return null; //if the uper coder did not work return null later
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAMgOVMmsWUB-1o9MT1exjiNIV-22EtiHM');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(response.body));
      notifyListeners();
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'][
            'message']); // if responsedata map has an error key that is not null; if it does, it throws an HttpException with a amessage equal to the value of 'message' field in the nexted error object
        // forwarding response data to have access to the error key  and inner map message key
      }
      _token = responseData[
          'idToken']; //we just set and store _token, _userid, _expirydate in memory
      _userId = responseData['localId'];
      _expirydate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
// class Auth with ChangeNotifier {
//   late String? _token;
//   DateTime? _expiryDate = DateTime.now();
//   late String? _userId;

//   Future<void> SignUp(String email, String password) async {
//     final url = Uri.parse(
//         'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyAMgOVMmsWUB-1o9MT1exjiNIV-22EtiHM');

//     final response = await http.post(url,
//         body: json.encode({
//           'email': email,
//           'password': password,
//           'returnSecureToken': true,
//         }));

//     if (response.statusCode >= 400) {
//       throw Exception('Failed to sign up');
//     }

//     final responseData = json.decode(response.body);
//     _token = responseData['idToken'];
//     _expiryDate = DateTime.now().add(
//       Duration(
//         seconds: int.parse(
//           responseData['expiresIn'],
//         ),
//       ),
//     );
//     _userId = responseData['localId'];

//     notifyListeners();
//   }

// if (response.body == null) {
//   throw Exception('Failed to load data');
// }

// final responseData = json.decode(response.body);
//}
