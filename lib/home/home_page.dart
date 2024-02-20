// // // Home Page :

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:sign_in_button/sign_in_button.dart';
// // import 'package:tracker/dashboard/dashboard.dart';
// // import 'package:tracker/dashboard/dashboard_page.dart';
// // import 'package:tracker/dashboard/message_view_list.dart';
// // import 'package:tracker/phoneAuthentication/phone_number_screen.dart';

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   List<SmsMessage> _messages = [];

// //   User? _user;

// //   // User user = currentUser;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _auth.authStateChanges().listen((event) {
// //       setState(() {
// //         _user = event;
// //       });
// //     });
// //   }

// //   // Future<void> saveUserDataToFirestore(User? user) async {
// //   //   if (user != null) {
// //   //     // Get a reference to the Firestore database
// //   //     final FirebaseFirestore firestore = FirebaseFirestore.instance;

// //   //     // Construct the data to be saved to Firestore
// //   //     final userData = {
// //   //       'uid': user.uid,
// //   //       'displayName': user.displayName,
// //   //       'email': user.email,
// //   //       // Add more user data fields as needed
// //   //     };

// //   //     // Save the user data to Firestore
// //   //     await firestore.collection('users').doc(user.uid).set(userData);
// //   //   } else {
// //   //     print('User is null. Unable to save data to Firestore.');
// //   //   }
// //   // }
// //   Future<void> saveUserDataToFirestore(User? user) async {
// //     try {
// //       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //       final DocumentReference userDocRef =
// //           _firestore.collection('users').doc(user!.uid);
// //       await userDocRef.set({
// //         'displayName': user.displayName,
// //         'email': user.email,
// //         'photoURL': user.photoURL,
// //       });
// //       print('User data saved to Firestore');
// //     } catch (error) {
// //       print('Error saving user data: $error');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             const Text("Google SignIn"),
// //             IconButton(
// //                 onPressed: () {
// //                   // saveUserDataToFirestore();
// //                   // saveUserDataToFirestore(user);
// //                 },
// //                 icon: Icon(Icons.cloud_upload))
// //           ],
// //         ),
// //       ),
// //       body: _user != null ? _userInfo() : _googleSignInButton(),
// //     );
// //   }

// //   // Future<void> _createUserDocument(User user) async {
// //   //   // Check if the user document already exists in Firestore
// //   //   final DocumentSnapshot userSnapshot =
// //   //       await _firestore.collection('users').doc(user.uid).get();

// //   //   if (!userSnapshot.exists) {
// //   //     // If the user document doesn't exist, create it
// //   //     await _firestore.collection('users').doc(user.uid).set({
// //   //       'name': user.displayName,
// //   //       'email': user.email,
// //   //     });

// //   //     // Create an SMS collection for the user
// //   //     await _firestore.collection('users').doc(user.uid).collection('sms').add({
// //   //       'sender': 'Sample Sender',
// //   //       'date': '2024-02-16',
// //   //       'message': 'Sample SMS message content',
// //   //     });
// //   //   }
// //   // }

// //   Widget _googleSignInButton() {
// //     return Center(
// //       child: SizedBox(
// //         height: 50,
// //         child: SignInButton(
// //           Buttons.google,
// //           text: "Sign up with Google",
// //           // onPressed: _handleGoogleSignIn,
// //           onPressed: () async {
// //             User? user = await _handleSignIn();
// //             if (user != null) {
// //               await saveUserDataToFirestore(user);
// //             }
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   // void saveUserDataToFirestore(User user) {
// //   //   // Access Firestore instance
// //   //   FirebaseFirestore firestore = FirebaseFirestore.instance;

// //   //   // Reference to the 'users' collection in Firestore
// //   //   CollectionReference users = firestore.collection('users');

// //   //   // Add a new document with a generated ID
// //   //   users.doc(user.uid).set({
// //   //     'displayName': user.displayName,
// //   //     'email': user.email,
// //   //     // Add more fields as needed
// //   //   }).then((_) {
// //   //     print("User data added to Firestore successfully!");
// //   //   }).catchError((error) {
// //   //     print("Error adding user data to Firestore: $error");
// //   //   });
// //   // }

// //   Widget _userInfo() {
// //     return SizedBox(
// //       width: MediaQuery.of(context).size.width,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         mainAxisSize: MainAxisSize.max,
// //         children: [
// //           Container(
// //             height: 100,
// //             width: 100,
// //             decoration: BoxDecoration(
// //               image: DecorationImage(
// //                 image: NetworkImage(_user!.photoURL!),
// //               ),
// //             ),
// //           ),
// //           Text(_user!.email!),
// //           Text(_user!.displayName ?? ""),
// //           MaterialButton(
// //             color: Colors.red,
// //             child: const Text("Sign Out"),
// //             onPressed: _auth.signOut,
// //           ),
// //           SizedBox(
// //             height: 20,
// //           ),
// //           MaterialButton(
// //             color: Colors.blue,
// //             child: const Text("Tracker App"),
// //             onPressed: () {
// //               Navigator.of(context).push(MaterialPageRoute(
// //                   builder: (context) => DashboardPage(messages: _messages)));
// //             },
// //           ),
// //           MaterialButton(
// //             color: Colors.blue,
// //             child: const Text("Firestore Data"),
// //             onPressed: () {
// //               Navigator.of(context)
// //                   .push(MaterialPageRoute(builder: (context) => Dashboard()));
// //             },
// //           ),
// //           MaterialButton(
// //             color: Colors.blue,
// //             child: const Text("Phone App"),
// //             onPressed: () {
// //               Navigator.of(context).push(
// //                   MaterialPageRoute(builder: (context) => PhoneAuthScreen()));
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _handleGoogleSignIn() {
// //     try {
// //       GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
// //       _auth.signInWithProvider(_googleAuthProvider);
// //     } catch (error) {
// //       print(error);
// //     }
// //   }

// //   // Future<User?> _handleSignIn() async {
// //   //   final GoogleSignIn googleSignIn = GoogleSignIn();
// //   //   try {
// //   //     final GoogleSignInAccount? googleSignInAccount =
// //   //         await googleSignIn.signIn();
// //   //     if (googleSignInAccount != null) {
// //   //       final GoogleSignInAuthentication googleSignInAuthentication =
// //   //           await googleSignInAccount.authentication;
// //   //       final AuthCredential credential = GoogleAuthProvider.credential(
// //   //         accessToken: googleSignInAuthentication.accessToken,
// //   //         idToken: googleSignInAuthentication.idToken,
// //   //       );
// //   //       final UserCredential userCredential =
// //   //           await _auth.signInWithCredential(credential);
// //   //       final User? user = userCredential.user;
// //   //       return user;
// //   //     }
// //   //   } catch (error) {
// //   //     print('Error signing in: $error');
// //   //   }
// //   //   return null;
// //   // }
// //   Future<User?> _handleSignIn() async {
// //     final GoogleSignIn googleSignIn = GoogleSignIn();
// //     try {
// //       final GoogleSignInAccount? googleSignInAccount =
// //           await googleSignIn.signIn();
// //       if (googleSignInAccount != null) {
// //         final GoogleSignInAuthentication googleSignInAuthentication =
// //             await googleSignInAccount.authentication;
// //         final AuthCredential credential = GoogleAuthProvider.credential(
// //           accessToken: googleSignInAuthentication.accessToken,
// //           idToken: googleSignInAuthentication.idToken,
// //         );
// //         final UserCredential userCredential =
// //             await _auth.signInWithCredential(credential);
// //         final User? user = userCredential.user;
// //         if (user != null) {
// //           // Create user document in Firestore
// //           // await _createUserDocument(user);
// //           await _associateSMSWithUser(user);
// //           // await addSMSToUserCollection  (user);
// //         }
// //         return user;
// //       }
// //     } catch (error) {
// //       print('Error signing in: $error');
// //     }
// //     return null;
// //   }

// //   Future<void> _associateSMSWithUser(User user) async {
// //     try {
// //       final FirebaseFirestore firestore = FirebaseFirestore.instance;
// //       final CollectionReference smsCollection = firestore.collection('sms');

// //       final QuerySnapshot smsQuerySnapshot = await smsCollection.get();

// //       for (final QueryDocumentSnapshot smsDoc in smsQuerySnapshot.docs) {
// //         final Map<String, dynamic>? smsData =
// //             smsDoc.data() as Map<String, dynamic>?;
// //         if (smsData != null) {
// //           // Check if the SMS already associated with the user
// //           final DocumentReference userSmsRef = firestore
// //               .collection('users')
// //               .doc(user.uid)
// //               .collection('user_sms')
// //               .doc(smsDoc.id);

// //           final DocumentSnapshot userSmsSnapshot = await userSmsRef.get();
// //           if (!userSmsSnapshot.exists) {
// //             // If not associated, then associate it
// //             await userSmsRef.set(smsData);
// //           }
// //         }
// //       }
// //       print('SMS associated with user: ${user.displayName}');
// //     } catch (error) {
// //       print('Error associating SMS with user: $error');
// //     }
// //   }

// //   // Future<void> _associateSMSWithUser(User user) async {
// //   //   try {
// //   //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
// //   //     final QuerySnapshot smsQuerySnapshot =
// //   //         await firestore.collection('sms').get();

// //   //     final List<DocumentSnapshot> smsDocs = smsQuerySnapshot.docs;
// //   //     for (final DocumentSnapshot smsDoc in smsDocs) {
// //   //       final Map<String, dynamic>? smsData =
// //   //           smsDoc.data() as Map<String, dynamic>?;
// //   //       if (smsData != null) {
// //   //         // Associate SMS with user using a unique identifier
// //   //         await firestore
// //   //             .collection('users')
// //   //             .doc(user.uid)
// //   //             .collection('user_sms')
// //   //             .doc(smsDoc.id)
// //   //             .set(smsData);
// //   //       }
// //   //     }
// //   //     print('SMS associated with user: ${user.displayName}');
// //   //   } catch (error) {
// //   //     print('Error associating SMS with user: $error');
// //   //   }
// //   // }

// //   // Future<void> addSMSToUserCollection(User user, String smsBody) async {
// //   //   try {
// //   //     // Get reference to Firestore collection 'sms'
// //   //     CollectionReference smsCollection =
// //   //         FirebaseFirestore.instance.collection('sms');

// //   //     // Add SMS document with reference to user document
// //   //     await smsCollection.add({
// //   //       'userId': user.uid, // Reference to user document
// //   //       'body': smsBody,
// //   //       'timestamp': Timestamp.now(), // Add timestamp for sorting
// //   //     });
// //   //   } catch (error) {
// //   //     print('Error adding SMS to collection: $error');
// //   //   }
// //   // }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_button/sign_in_button.dart';
// import 'package:tracker/dashboard/dashboard.dart';
// import 'package:tracker/dashboard/dashboard_page.dart';
// import 'package:tracker/dashboard/message_view_list.dart';
// import 'package:tracker/phoneAuthentication/phone_number_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<SmsMessage> _messages = [];
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _auth.authStateChanges().listen((event) {
//       setState(() {
//         _user = event;
//       });
//     });
//   }

//   Future<void> saveUserDataToFirestore(User? user) async {
//     try {
//       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//       final DocumentReference userDocRef =
//           _firestore.collection('users').doc(user!.uid);
//       await userDocRef.set({
//         'displayName': user.displayName,
//         'email': user.email,
//         'photoURL': user.photoURL,
//       });
//       print('User data saved to Firestore');
//     } catch (error) {
//       print('Error saving user data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Google SignIn"),
//             // IconButton(
//             //   onPressed: () {},
//             //   icon: Icon(Icons.cloud_upload),
//             // ),
//             Container(

//               height: 50,
//               width: 50,
//               decoration: BoxDecoration(

//                 image: DecorationImage(
//                   image: NetworkImage(_user!.photoURL!),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: _user != null ? _userInfo() : _googleSignInButton(),
//     );
//   }

//   Widget _googleSignInButton() {
//     return Center(
//       child: SizedBox(
//         height: 50,
//         child: SignInButton(
//           Buttons.google,
//           text: "Sign up with Google",
//           onPressed: () async {
//             User? user = await _handleSignIn();
//             if (user != null) {
//               await saveUserDataToFirestore(user);
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _userInfo() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(_user!.photoURL!),
//               ),
//             ),
//           ),
//           Text(_user!.email!),
//           Text(_user!.displayName ?? ""),
//           MaterialButton(
//             color: Colors.red,
//             child: const Text("Sign Out"),
//             onPressed: _auth.signOut,
//           ),
//           SizedBox(height: 20),
//           MaterialButton(
//             color: Colors.blue,
//             child: const Text("Tracker App"),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => DashboardPage(messages: _messages)));
//             },
//           ),
//           MaterialButton(
//             color: Colors.blue,
//             child: const Text("Firestore Data"),
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => Dashboard()));
//             },
//           ),
//           MaterialButton(
//             color: Colors.blue,
//             child: const Text("Phone App"),
//             onPressed: () {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => PhoneAuthScreen()));
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<User?> _handleSignIn() async {
//     final GoogleSignIn googleSignIn =
//         GoogleSignIn(scopes: ['https://mail.google.com/']);
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//         final UserCredential userCredential =
//             await _auth.signInWithCredential(credential);
//         final User? user = userCredential.user;
//         if (user != null) {
//           await _associateSMSWithUser(user);
//           await fetchEmails(googleSignInAuthentication.accessToken!);
//         }
//         return user;
//       }
//     } catch (error) {
//       print('Error signing in: $error');
//     }
//     return null;
//   }

//   Future<void> fetchEmails(String accessToken) async {
//     final url =
//         'https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=10';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//       },
//     );
//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       // Process the email data as needed
//       print(jsonData);
//     } else {
//       print('Failed to fetch emails: ${response.statusCode}');
//     }
//   }

//   Future<void> _associateSMSWithUser(User user) async {
//     try {
//       final FirebaseFirestore firestore = FirebaseFirestore.instance;
//       final CollectionReference smsCollection = firestore.collection('sms');
//       final QuerySnapshot smsQuerySnapshot = await smsCollection.get();

//       for (final QueryDocumentSnapshot smsDoc in smsQuerySnapshot.docs) {
//         final Map<String, dynamic>? smsData =
//             smsDoc.data() as Map<String, dynamic>?;
//         if (smsData != null) {
//           final DocumentReference userSmsRef = firestore
//               .collection('users')
//               .doc(user.uid)
//               .collection('user_sms')
//               .doc(smsDoc.id);

//           final DocumentSnapshot userSmsSnapshot = await userSmsRef.get();
//           if (!userSmsSnapshot.exists) {
//             await userSmsRef.set(smsData);
//           }
//         }
//       }
//       print('SMS associated with user: ${user.displayName}');
//     } catch (error) {
//       print('Error associating SMS with user: $error');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:tracker/dashboard/dashboard.dart';
import 'package:tracker/dashboard/dashboard_page.dart';
import 'package:tracker/dashboard/message_view_list.dart';
import 'package:tracker/phoneAuthentication/phone_number_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SmsMessage> _messages = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  Future<void> saveUserDataToFirestore(User? user) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(user!.uid);
      await userDocRef.set({
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
      });
      print('User data saved to Firestore');
    } catch (error) {
      print('Error saving user data: $error');
    }
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign up with Google",
          onPressed: () async {
            User? user = await _handleSignIn();
            if (user != null) {
              await saveUserDataToFirestore(user);
            }
          },
        ),
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
              ),
            ),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          MaterialButton(
            color: Colors.red,
            child: const Text("Sign Out"),
            onPressed: _auth.signOut,
          ),
          SizedBox(height: 20),
          MaterialButton(
            color: Colors.blue,
            child: const Text("Tracker App"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DashboardPage(messages: _messages)));
            },
          ),
          MaterialButton(
            color: Colors.blue,
            child: const Text("Firestore Data"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
          MaterialButton(
            color: Colors.blue,
            child: const Text("Phone App"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PhoneAuthScreen()));
            },
          ),
        ],
      ),
    );
  }

  Future<User?> _handleSignIn() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: ['https://mail.google.com/']);
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          await _associateSMSWithUser(user);
        }
        return user;
      }
    } catch (error) {
      print('Error signing in: $error');
    }
    return null;
  }

  Future<void> fetchEmails(String accessToken) async {
    final url =
        'https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=10';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Process the email data as needed
      print(jsonData);
      return jsonData['messages']; // Return the email messages
    } else {
      print('Failed to fetch emails: ${response.statusCode}');
      throw Exception('Failed to fetch emails');
    }
  }

  Future<void> _associateSMSWithUser(User user) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference smsCollection = firestore.collection('sms');
      final QuerySnapshot smsQuerySnapshot = await smsCollection.get();

      for (final QueryDocumentSnapshot smsDoc in smsQuerySnapshot.docs) {
        final Map<String, dynamic>? smsData =
            smsDoc.data() as Map<String, dynamic>?;
        if (smsData != null) {
          final DocumentReference userSmsRef = firestore
              .collection('users')
              .doc(user.uid)
              .collection('user_sms')
              .doc(smsDoc.id);

          final DocumentSnapshot userSmsSnapshot = await userSmsRef.get();
          if (!userSmsSnapshot.exists) {
            await userSmsRef.set(smsData);
          }
        }
      }
      print('SMS associated with user: ${user.displayName}');
    } catch (error) {
      print('Error associating SMS with user: $error');
    }
  }

  Widget _buildEmailList(List<dynamic> emails) {
    return ListView.builder(
      itemCount: emails.length,
      itemBuilder: (context, index) {
        final email = emails[index];
        return ListTile(
          title: Text(email['snippet']), // Display email snippet
          // Customize ListTile to display more email details
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Google SignIn"),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.cloud_upload),
            ),
          ],
        ),
      ),
      body: _user != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _userInfo(),
                ),
                Expanded(
                  flex: 3,
                  child: FutureBuilder<void>(
                    future: fetchEmails(
                        _user!.uid), // Call fetchEmails with user ID
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        // Email data is fetched successfully
                        final List<dynamic> emails =
                            snapshot.data as List<dynamic>;
                        return _buildEmailList(
                            emails); // Display the email list
                      }
                    },
                  ),
                ),
              ],
            )
          : _googleSignInButton(),
    );
  }
}
