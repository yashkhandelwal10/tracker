import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
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
                count: 20,
              );
              debugPrint('sms inbox messages: ${messages.length}');

              setState(() => _messages = messages);
            } else {
              await Permission.sms.request();
            }
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;
  String keyword = "Rs";
  String keyword1 = "INR";
  List<String> sentTxn = ['sent', 'debit', 'debited'];
  List<String> receivedTxn = ['received', 'credit', 'credited'];

  String? findKeyword(List<SmsMessage> messages, List<String> sentKeywords,
      List<String> receivedKeywords) {
    // Convert the SMS body to lowercase for case-insensitive matching
    List<String> smsBodies =
        messages.map((message) => message.body?.toLowerCase() ?? "").toList();

    // Check if any part of the SMS body contains sent keywords
    for (String body in smsBodies) {
      for (String keyword in sentKeywords) {
        if (body.contains(keyword.toLowerCase())) {
          return keyword;
        }
      }
    }

    // Check if any part of the SMS body contains received keywords
    for (String body in smsBodies) {
      for (String keyword in receivedKeywords) {
        if (body.contains(keyword.toLowerCase())) {
          return keyword;
        }
      }
    }

    // If no match is found, return null
    return null;
  }

  List<SmsMessage> filterMessages(
      List<SmsMessage> messages, String keyword, String keyword1) {
    return messages
        .where((message) =>
            message.body != null &&
                message.body!.toLowerCase().contains(keyword.toLowerCase()) ||
            message.body!.toLowerCase().contains(keyword1.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<SmsMessage> filteredMessages =
        filterMessages(messages, keyword, keyword1);
    String? key = findKeyword(messages, sentTxn, receivedTxn);

    return ListView.builder(
      shrinkWrap: true,
      // itemCount: messages.length,
      itemCount: filteredMessages.length,
      itemBuilder: (BuildContext context, int i) {
        // var message = messages[i];
        var message = filteredMessages[i];
        var paragraph = message.body;
        if (key != null) {
          print("Keyword found: $key");
        } else {
          print("No matching keyword found in the SMS body");
        }

        // Trim paragraph based on keyword reference

        String trimParagraph(
            String paragraph, String keyword, String keyword1) {
          int keywordIndex =
              paragraph.toLowerCase().indexOf(keyword.toLowerCase());
          int keywordIndex1 =
              paragraph.toLowerCase().indexOf(keyword1.toLowerCase());
          if (keywordIndex != -1) {
            int startIndex = paragraph.indexOf(" ", keywordIndex) + 1;
            int endIndex = paragraph.indexOf(" ", startIndex);
            if (endIndex == -1) {
              endIndex = paragraph.length;
            }
            return paragraph.substring(startIndex, endIndex).trim();
          } else if (keywordIndex1 != -1) {
            int startIndex = paragraph.indexOf(" ", keywordIndex1) + 1;
            int endIndex = paragraph.indexOf(" ", startIndex);
            if (endIndex == -1) {
              endIndex = paragraph.length;
            }
            return paragraph.substring(startIndex, endIndex).trim();
          }
          return paragraph;
        }

        String trimmedParagraph = trimParagraph(paragraph!, keyword, keyword1);

        // return ListTile(
        //   title: Text('${message.sender} [${message.date}]'),
        //   // subtitle: Text('${message.body}'),
        //   subtitle:
        //       Align(alignment: Alignment.center, child: Text(trimmedParagraph)),
        // );
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${message.sender}'),
                  Column(
                    children: [
                      Text(
                        trimmedParagraph,
                        style: TextStyle(
                          // color: sentTxn.any((keyword) =>
                          //         trimmedParagraph.contains(keyword))
                          //     ? Colors.red
                          //     : receivedTxn.any((keyword) =>
                          //             trimmedParagraph.contains(keyword))
                          //         ? Colors.green
                          //         : Colors.grey,
                          color: sentTxn.any((keyword) => trimmedParagraph
                                  .toLowerCase()
                                  .contains(keyword.toLowerCase()))
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      Text('${message.date}'),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}
