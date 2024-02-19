// Can you check what is the issue in the below code that is not giving me data after clicking on fetch data button :
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> userData = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SMS Date: ${userData[index]['smsDate']}'),
                        Text('SMS Message: ${userData[index]['smsMessage']}'),
                        Text('SMS Sender: ${userData[index]['smsSender']}'),
                        Text('User SMS Data:'),
                        ...userData[index]['userSmsData']
                            .map<Widget>((userSms) {
                          DateTime dateTime =
                              (userSms['date'] as Timestamp).toDate();
                          String formattedDate =
                              DateFormat.yMd().add_jm().format(dateTime);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  Body: ${userSms['body']}'),
                              Text('  Date: $formattedDate'),
                              Text('  Sender: ${userSms['sender']}'),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Reference to the Firestore collection "users"
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        // Fetch documents from the "sms" collection under the current user
        QuerySnapshot smsSnapshot =
            await usersCollection.doc(user.uid).collection('sms').get();

        // Fetch data from the "user_sms" collection under the current user
        QuerySnapshot userSmsSnapshot =
            await usersCollection.doc(user.uid).collection('user_sms').get();

        // Iterate through each document in the "sms" collection
        smsSnapshot.docs.forEach((smsDoc) {
          // Fetch data only if the SMS message contains the keywords 'Rs.' or 'INR'
          if ((smsDoc['message'] as String).toLowerCase().contains('rs.') ||
              (smsDoc['message'] as String).toLowerCase().contains('inr')) {
            // Combine SMS and user SMS data
            List<Object?> userSmsData =
                userSmsSnapshot.docs.map((doc) => doc.data()).toList();

            userData.add({
              'smsDate': (smsDoc['date'] as Timestamp).toDate(),
              'smsMessage': smsDoc['message'],
              'smsSender': smsDoc['sender'],
              'userSmsData': userSmsData,
            });
          }
        });

        // Update UI with new data
        setState(() {});
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
