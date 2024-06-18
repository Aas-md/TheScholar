
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:my_scholar/views/home/profile_screen.dart';

//
import 'dart:convert';

import 'package:crypto/crypto.dart';
// import 'package:jwt/jwt.dart';
import 'dart:io';

class NotificationService{

  FirebaseMessaging messaging= FirebaseMessaging.instance;
 final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission()async{

    NotificationSettings settings = await messaging.requestPermission(

      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permission');
    }else{
      print('user denied permission');
    }

  }

  void initNotification(BuildContext context,RemoteMessage message)async{
    var ais = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: ais
    );
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
    onDidReceiveNotificationResponse: (payload){
      handleMessage(context,message);
    }

    );
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['id'].toString());
        print(message.data['type'].toString());
      }


      if (Platform.isAndroid) {
        initNotification(context, message);
        showNotification(message);
      }
      // showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'high importance notification',
      importance: Importance.max
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );

    NotificationDetails notificationDetails = NotificationDetails(

      android: androidNotificationDetails
    );
    Future.delayed(
      Duration.zero,
    () {
          _flutterLocalNotificationsPlugin.show(
              0,
              message.notification!.title.toString(),
              message.notification!.body.toString(),
              notificationDetails
           );
        });
    }

  Future<String?> getDeviceToken()async{
    return await messaging.getToken();
  }

  void isTokenRefresh(){
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void handleMessage(BuildContext context,RemoteMessage message){
      if(message.data['type'] == 'profile screen'){
        Get.toNamed('/ProfileScreen');
      }
  }

  Future<void> setupInteractMessage(BuildContext context)async{
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }

    // when app is  in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });

  }



  List<String> SCOPES = ['https://www.googleapis.com/auth/firebase.messaging'];

  Future<String> getAccessToken() async {
    // Load the service account JSON file
    final String jsonString = await rootBundle.loadString('service-account.json');
    final serviceAccount = jsonDecode(jsonString);

    final String clientEmail = serviceAccount['client_email'];
    final String privateKey = serviceAccount['private_key'];
    final String tokenUri = serviceAccount['token_uri'];

    final int iat = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final int exp = iat + 3600;

    // Create JWT header
    final jwtHeader = {
      'alg': 'RS256',
      'typ': 'JWT',
    };

    // Create JWT payload
    final jwtPayload = {
      'iss': clientEmail,
      'scope': SCOPES.join(' '),
      'aud': tokenUri,
      'iat': iat,
      'exp': exp,
    };

    // Encode the header and payload
    final String encodedHeader = base64UrlEncode(utf8.encode(jsonEncode(jwtHeader)));
    final String encodedPayload = base64UrlEncode(utf8.encode(jsonEncode(jwtPayload)));

    // Create the signing input
    final String signingInput = '$encodedHeader.$encodedPayload';

    // Sign the JWT
    final privateKeyPem = privateKey.replaceAll('\\n', '\n');
    final key = JsonWebKey.fromPem(privateKeyPem, keyId: null);
    final signer = JsonWebSignatureBuilder()
      ..setProtectedHeader('alg', 'RS256')
      ..jsonContent = jwtPayload
      ..addRecipient(key, algorithm: 'RS256');

    final signedJwt = signer.build().toCompactSerialization();

    // Request the access token
    final response = await http.post(
      Uri.parse(tokenUri),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': signedJwt,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['access_token'];
    } else {
      throw Exception('Failed to obtain access token: ${response.body}');
    }
  }



}
