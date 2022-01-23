import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

final ScrollController _scrollController = ScrollController();

class _ChatPageState extends State<ChatPage> {
  late CollectionReference messages;
  late Stream<QuerySnapshot> _messageStream;
  late String username;
  late Map arguments;
  late String _message;
  final TextEditingController messageTF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _messageStream = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    messages = FirebaseFirestore.instance.collection('chats');
    Future.delayed(const Duration(milliseconds: 700), () {
      _scrollToBottom();
    });
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quipster'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _messageStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      controller: _scrollController,
                      children: _getMessage(snapshot, "User1"),
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

  _getMessage(AsyncSnapshot<QuerySnapshot> snapshot, String username) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      if (arguments['user'] == data['username']) {
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
                            maxWidth: MediaQuery.of(context).size.width - 150),
                        child: Text(data['message']),
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(arguments['user'].toString().substring(0, 1)),
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
                      child: Text(arguments['user'].toString().substring(0, 1)),
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
                            maxWidth: MediaQuery.of(context).size.width - 150),
                        child: Text(data['message']),
                      ),
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
    int _timeStamp = DateTime.now().millisecondsSinceEpoch;
    return messages
        .doc()
        .set({
          'message': _messageToBeSent,
          'username': arguments['user'],
          'timestamp': _timeStamp
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
