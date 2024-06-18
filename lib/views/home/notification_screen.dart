import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/notification_service.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationService = NotificationService();
  String _accessToken = '';

  Future<void> _generateAccessToken() async {
    try {
      final token = await notificationService.getAccessToken();

      _accessToken = token;

    } catch (error) {
      if (kDebugMode) {
        print('Error generating access token: $error');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notificationService.setupInteractMessage(context);
    notificationService.isTokenRefresh();
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    _generateAccessToken();
    notificationService.getDeviceToken().then((value) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Get.back())),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: 10, //posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: index / 4 == 0
                          ? const Text('someone comment on your post')
                          : const Text('someone Liked Your Post'),
                      trailing: const Text('2 hours ago'),
                    );
                  }))
        ],
      ),
    );
  }
}

//code for sending notificartions but not working due to server key .

// TextButton(onPressed: (){
//
// notificationService.getDeviceToken().then((value)async{
// print('value -> $value');
// var data = {
// 'to': value.toString(),
// 'priority' : 'high',
// 'notification' : {
// 'title' : 'Aisf Taj',
// 'body' : 'this is the body'
// }
//
// };
// const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/my-scholar-5fca8/messages:send';
//
// await http.post(Uri.parse(fcmEndpoint),
// body: jsonEncode(data),
// headers: {
// 'Content-Type' : 'application/json; charset=UTF-8',
// 'Authorization': 'Bearer ' + _accessToken
// }
// ).then((value) => print('successfully sent->$value'))
//     .onError((error, stackTrace) => print('error in http ->${error.toString()}'));
// print('access token-> $_accessToken');
//
// });
//
//
// }, child: const Text('push notification'))
