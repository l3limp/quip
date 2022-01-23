import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RealChatPage extends StatefulWidget {
  const RealChatPage({Key? key}) : super(key: key);

  @override
  _RealChatPageState createState() => _RealChatPageState();
}

final ScrollController _scrollController = ScrollController();

class _RealChatPageState extends State<RealChatPage> {
  late CollectionReference messages;
  late Stream<QuerySnapshot> _messageStream;
  late String username;
  late String _message;
  late Map arguments;
  final TextEditingController messageTF = TextEditingController();
  late User? _user;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _user = FirebaseAuth.instance.currentUser;
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _messageStream = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(arguments['docName'])
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
    messages = FirebaseFirestore.instance.collection('messages');
    Future.delayed(const Duration(milliseconds: 700), () {
      _scrollToBottom();
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(arguments['username']),
          backgroundColor: Colors.green,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _messageStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      controller: _scrollController,
                      children: _getMessage(snapshot),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: messageTF,
                      key: Key('jew'),
                      onChanged: (value) {
                        _message = value;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Enter Message...",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _sendMessage(_message);
                      FocusScope.of(context).unfocus();
                      messageTF.clear();
                      _scrollToBottom();
                    },
                    icon: Icon(Icons.send),
                    color: Colors.green)
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  _getMessage(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      if (data['senderID'] == _user!.uid) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 150),
                          child: Text(data['text'])),
                    ),
                    alignment: Alignment.bottomRight,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text("Me"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.pink,
                      child: Text(
                          arguments['username'].toString().substring(0, 1)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 150),
                          child: Text(data['text'])),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }).toList();
  }

  Future<void> _sendMessage(String _messageToBeSent) {
    CollectionReference _chatRooms =
        FirebaseFirestore.instance.collection('chatrooms');
    return _chatRooms
        .doc(arguments['docName'])
        .collection('messages')
        .doc()
        .set({
      'text': _messageToBeSent,
      'senderID': _user!.uid,
      'timestamp': Timestamp.now()
    });
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
