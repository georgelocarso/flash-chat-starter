import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';


final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static final String id = "chatscreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

late final User loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String messageText = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // messagesStream();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("========================");
        print(loggedInUser.email);
      } else {
        print("user is null");
        print(user);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();

  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }

  //     print("================================================");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                try {
                  _auth.signOut();
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Set transparent background
                      shadowColor: Colors.transparent, // Remove shadow
                    ),
                    onPressed: () {
                      messageTextController.clear();
                      try {
                        // messageText + loggedInUser Email
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'timeStamp': Timestamp.now(),
                        });
                      } catch (e) {
                        print(e);
                      } finally {
                        // getMessages();
                        print("sent message: " + messageText);
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('messages').orderBy("timeStamp", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          } else {
            final currentUser = loggedInUser.email;

            

            List<MessageBubble> messageBubbles = [];
            for (var doc in snapshot.data!.docs) {
              final messageSender = doc['sender'];
              final messageText = doc['text'];
              final timeStamp = doc['timeStamp'];
              print(doc['sender'] + ":" + doc['text']);

              messageBubbles.add(MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: currentUser == messageSender,
                timeStamp: timeStamp,
              ));
            }
            print("===");

            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: messageBubbles,
              ),
            );
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender = "",
      this.text = "",
      this.isMe = false,
      required this.timeStamp});

  final String sender;
  final String text;
  final Timestamp timeStamp;
  final bool isMe;

  


    
    
   

  @override
  Widget build(BuildContext context) {
    var time = formatDate(timeStamp.toDate(), [HH,':',nn]);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender [$time]",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
