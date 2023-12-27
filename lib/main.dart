// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController senderTextEditingController = TextEditingController();
  TextEditingController receivedEditingController = TextEditingController();
  String result = 'Suggestions...';
  late SmartReply smartReply;

  @override
  void initState() {
    //implement initState
    super.initState();
    smartReply = SmartReply();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, left: 13, right: 13),
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: receivedEditingController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: 'Received Text here...',
                                  filled: true,
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        smartReply.addMessageToConversationFromRemoteUser(
                            receivedEditingController.text,
                            DateTime.now().millisecondsSinceEpoch,
                            'userId');
                        receivedEditingController.clear();
                        result = '';
                        final response = await smartReply.suggestReplies();
                        for (final suggestion in response.suggestions) {
                          print('suggestion: $suggestion');
                          result += '$suggestion\n';
                        }
                        setState(() {
                          result;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.only(
                              top: 13, left: 15, bottom: 13, right: 12),
                          backgroundColor: Colors.red),
                      child: const Icon(
                        Icons.send,
                        size: 25,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Colors.black,
                  child: Center(
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          result,
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 20, left: 13, right: 13, bottom: 15),
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                     Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: senderTextEditingController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: 'Sender Text here...',
                                  filled: true,
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        smartReply.addMessageToConversationFromLocalUser(
                            senderTextEditingController.text,
                            DateTime.now().millisecondsSinceEpoch);
                        senderTextEditingController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.only(
                              top: 13, left: 15, bottom: 13, right: 12),
                          backgroundColor: Colors.green),
                      child: const Icon(
                        Icons.send,
                        size: 25,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
