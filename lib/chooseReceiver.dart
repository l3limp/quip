import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChooseReceiver extends StatefulWidget {
  const ChooseReceiver({Key? key}) : super(key: key);

  @override
  _ChooseReceiverState createState() => _ChooseReceiverState();
}

late CollectionReference _users;
late Stream<QuerySnapshot> _userStream;
String _userID = "";
late bool isSmallerUser;

class _ChooseReceiverState extends State<ChooseReceiver> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    _userStream = FirebaseFirestore.instance.collection('users').snapshots();
    _users = FirebaseFirestore.instance.collection('users');
    _userID = _auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quipster'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              child: Center(child: Text("Me: " + _user!.email.toString())),
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.green, width: 2)),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _userStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: _getUserList(snapshot),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getUserList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      if (_user!.uid == document.id) {
        return SizedBox(
          height: 0,
        );
      } else {
        return InkWell(
          onTap: () {
            getChatroom(document.id, data['username']);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['username'],
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  data['emailID'],
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
    }).toList();
  }

  Future<void> getChatroom(String receiverUID, String username) async {
    CollectionReference _chatRooms =
        FirebaseFirestore.instance.collection('chatrooms');

    if (_userID.compareTo(receiverUID) < 0) {
      isSmallerUser = true;
    } else {
      isSmallerUser = false;
    }
    String docName = "";
    // var doc1 = await _chatRooms.doc(_userID + "_" + receiverUID).get();
    // var doc2 = await _chatRooms.doc(receiverUID + "_" + _userID).get();
    if (isSmallerUser) {
      docName = _userID + "_" + receiverUID;
    } else {
      docName = receiverUID + "_" + _userID;
    }

    if (isSmallerUser) {
      Navigator.pushNamed(context, '/f', arguments: {
        'receiver_UID': receiverUID,
        'docName': docName,
        'username': username
      });
    } else if (!isSmallerUser) {
      Navigator.pushNamed(context, '/f', arguments: {
        'receiver_UID': receiverUID,
        'docName': docName,
        'username': username
      });
    } else {
      print("new created");
      await _chatRooms
          .doc(_userID + "_" + receiverUID)
          .collection('messages')
          .doc()
          .set({}).then((value) => Navigator.pushNamed(context, '/f',
                  arguments: {
                    'receiver_UID': receiverUID,
                    'docName': docName,
                    'username': username
                  }));
    }
  }

  // await _chatRooms
  //     .doc(_userID + "_" + receiverUID)
  //     .get()
  //     .then((DocumentSnapshot documentSnapshot) async {
  //   if (documentSnapshot.exists) {
  //     Navigator.pushNamed(context, '/f', arguments: {
  //       'receiver_UID': receiverUID,
  //       'docName': _userID + "_" + receiverUID
  //     });
  //   } else {
  //     await _chatRooms
  //         .doc(receiverUID + "_" + _userID)
  //         .get()
  //         .then((value) async {
  //       if (value.exists) {
  //         Navigator.pushNamed(context, '/f', arguments: {
  //           'receiver_UID': receiverUID,
  //           'docName': receiverUID + "_" + _user!.uid
  //         });
  //       } else {
  //         await _chatRooms
  //             .doc(_userID + "_" + receiverUID)
  //             .collection('messages')
  //             .doc()
  //             .set({}).then((value) => Navigator.pushNamed(context, '/f',
  //                     arguments: {
  //                       'receiver_UID': receiverUID,
  //                       'docName': _userID + "_" + receiverUID
  //                     }));
  //       }
  //     });
  //   }
  // });
}
