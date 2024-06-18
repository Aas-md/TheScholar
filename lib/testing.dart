import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  bool loading1 = false;
  bool loading2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          GestureDetector(
              onTap: loading1 || loading2
                  ? null
                  : () {
                      setState(() {
                        loading1 = true;
                      });
                      print('inside loading 1');
                      Timer(const Duration(seconds: 3), () {
                        // Execute your function here after 3 minutes

                        setState(() {
                          loading1 = false;
                        });
                      });
                    },
              child: Container(
                  height: 50,
                  width: 200,
                color: Colors.blue,
                  child :   Center(child:
                  loading1
                      ? const CircularProgressIndicator(color: Colors.white,) :
                  Text('loading1')))),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
              onTap: loading1 || loading2
                  ? null
                  : () {
                setState(() {
                  loading2 = true;
                });
                print('inside loading 2');
                      Timer(const Duration(seconds: 3), () {
                        // Execute your function here after 3 minutes

                       setState(() {
                         loading2 = false;
                       });
                      });
                    },
              child: Container(
                height: 50,
                  width: 200,
                  color: Colors.grey,

                  child: loading2
                      ? const CircularProgressIndicator()
                      : const Center(child: Text('loading2'))))
        ],
      ),
    );
  }
}
