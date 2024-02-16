import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker/dashboard/message_view_list.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  Future<void> _saveSMSToFirestore() async {
    CollectionReference smsCollection =
        FirebaseFirestore.instance.collection('sms');

    // var smsCollection = FirebaseFirestore.instance
    //     .collection('messages')
    //     .orderBy('date', descending: true);

    // Get the last saved SMS message's date
    DateTime? lastSavedDate;
    QuerySnapshot lastSMS =
        await smsCollection.orderBy('date', descending: true).limit(1).get();
    if (lastSMS.docs.isNotEmpty) {
      lastSavedDate = (lastSMS.docs.first['date'] as Timestamp).toDate();
    }

    // Filter new messages based on the last saved date
    List<SmsMessage> newMessages = _messages.where((message) {
      return lastSavedDate == null ||
          message.date!.millisecondsSinceEpoch >
              lastSavedDate.millisecondsSinceEpoch;
    }).toList();

    // Sort the new messages by their dates
    // newMessages.sort((a, b) => a.date!.compareTo(b.date));
    newMessages.sort(
        (a, b) => (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0)));

    // Save only the new messages to Firestore
    for (var message in newMessages) {
      // Convert message date to Firestore Timestamp
      Timestamp timestamp = Timestamp.fromDate(message.date!);

      // Format date as string for display
      String formattedDate =
          DateFormat('yyyy-MM-dd – kk:mm').format(message.date!);
      await smsCollection.add({
        'sender': message.sender,
        'date': message.date,
        'body': message.body,
        // 'formattedDate': formattedDate,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New SMS data saved to Firestore'),
      ),
    );
  }

  // Future<void> _saveSMSToFirestore() async {
  //   CollectionReference smsCollection =
  //       FirebaseFirestore.instance.collection('sms');

  //   // Get the last saved SMS message's date
  //   DateTime? lastSavedDate;
  //   QuerySnapshot lastSMS =
  //       await smsCollection.orderBy('date', descending: true).limit(1).get();
  //   if (lastSMS.docs.isNotEmpty) {
  //     lastSavedDate = (lastSMS.docs.first['date'] as Timestamp).toDate();
  //   }

  //   // Filter new messages based on the last saved date
  //   List<SmsMessage> newMessages = _messages.where((message) {
  //     return lastSavedDate == null ||
  //         message.date!.millisecondsSinceEpoch >
  //             lastSavedDate.millisecondsSinceEpoch;
  //   }).toList();

  //   // Save only the new messages to Firestore
  //   for (var message in newMessages) {
  //     await smsCollection.add({
  //       'sender': message.sender,
  //       'date': message.date,
  //       'body': message.body,
  //     });
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('New SMS data saved to Firestore'),
  //     ),
  //   );
  // }

  // Future<void> _saveSMSToFirestore() async {
  //   CollectionReference smsCollection =
  //       FirebaseFirestore.instance.collection('sms');

  //   for (var message in _messages) {
  //     await smsCollection.add({
  //       'sender': message.sender,
  //       'date': message.date,
  //       'body': message.body,
  //     });
  //   }
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('SMS data saved to Firestore'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // var xyz = _messages.;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SMS Inbox Example'),
            IconButton(
              icon: Icon(Icons.upload),
              onPressed: _saveSMSToFirestore,
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _messages.isNotEmpty
            ? MessagesListView(
                messages: _messages,
              )
            : Center(
                child: Text(
                  'No messages to show.\n Tap refresh button...',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.status;
          if (permission.isGranted) {
            final messages = await _query.querySms(
              kinds: [
                SmsQueryKind.inbox,
                SmsQueryKind.sent,
              ],
              // address: '+254712345789',
              count: 5,
            );
            debugPrint('sms inbox messages: ${messages.length}');

            setState(() => _messages = messages);
          } else {
            await Permission.sms.request();
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
