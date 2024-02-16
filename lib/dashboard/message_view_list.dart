import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesListView extends StatefulWidget {
  MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;
  

  addData(String title, DateTime date, String body) {
    if (title == "" && date == "" && body == "") {
      return null;
    } else {
      FirebaseFirestore.instance
          .collection("Users")
          .doc("title")
          .set({"Title": title, "Date and Time": date, "SMS Body": body}).then(
              (value) {
        log("Data Inserted" as num);
      });
    }
  }

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  
  String keyword = "Rs";

  String keyword1 = "INR";

  List<String> sentTxn = [
    'sent',
    'debit',
    'debited',
    'purchase',
    'deducted',
    'spent'
  ];

  List<String> receivedTxn = ['received', 'credit', 'credited'];

  List<String> shopping = [
    'amazon',
    'flipkart',
    'myntra',
    'meesho',
    'ajio',
    'upi:'
  ];

  List<String> ride = ['uber', 'ola', 'rapido'];

  List<String> food = ['swiggy', 'zomato', 'eatclub', 'bse'];

  List<String> investment = ['upstox', 'groww', 'zerodha', 'uti'];

  List<String> ott = [
    'netflix',
    'prime',
    'zee',
    'hotstar',
    'jiocinema',
    'sonylib'
  ];

  // String? findSender(
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

  // bool containsAnyKeyword(String text, List<String> keywords) {
  bool containsAnyKeyword(String text, List<String> keywords) {
    print("Text: $text");
    for (String keyword in keywords) {
      print("Checking keyword: $keyword");
      if (text.toLowerCase().contains(keyword.toLowerCase())) {
        print("Keyword found: $keyword");
        return true;
      }
    }
    return false;
  }

  String? getSenderCategory(String senderName) {
    if (shopping.any((keyword) => senderName.toLowerCase().contains(keyword))) {
      return "Shopping";
    } else if (ride
        .any((keyword) => senderName.toLowerCase().contains(keyword))) {
      return "Ride";
    } else if (food
        .any((keyword) => senderName.toLowerCase().contains(keyword))) {
      return "Food";
    } else if (investment
        .any((keyword) => senderName.toLowerCase().contains(keyword))) {
      return "Investment";
    } else if (ott
        .any((keyword) => senderName.toLowerCase().contains(keyword))) {
      return "OTT";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<SmsMessage> filteredMessages =
        filterMessages(widget.messages, keyword, keyword1);
    String? key = findKeyword(widget.messages, sentTxn, receivedTxn);
    // String? senderCategory1 =
    //     findSender(messages, shopping, ride, food, investment, ott);

    return ListView.builder(
      shrinkWrap: true,
      // itemCount: messages.length,
      itemCount: filteredMessages.length,
      itemBuilder: (BuildContext context, int i) {
        // var message = messages[i];
        var message = filteredMessages[i];
        var paragraph = message.body;
        // var senderName = message.sender;
        // filteredMessages.forEach((message) {
        //   senderName = senderCategory ?? message.sender;
        // });

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
        String? senderCategory = getSenderCategory(message.sender ?? "");

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
                  Text('${senderCategory ?? message.sender}'),
                  // Text('${message.sender}'),
                  // Text(senderName!),
                  // Text(senderName == investment ? 'investment' : 'XYZ'),

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
                          // color: sentTxn.any((keyword) => trimmedParagraph
                          //         .toLowerCase()
                          //         .contains(keyword.toLowerCase()))
                          //     ? Colors.red
                          //     : Colors.green,
                          color: containsAnyKeyword(paragraph, sentTxn)
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
