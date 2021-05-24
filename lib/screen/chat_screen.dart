import 'package:Toast/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';
import 'package:pubnub/src/dx/_endpoints/history.dart';
import 'constant.dart';

class ChatScreen extends StatelessWidget {
  static const String id = 'chat_screen';
  final String email;

  ChatScreen({this.email});

  @override
  Widget build(BuildContext context) {
    final PubNub pubNub = PubNub(
      defaultKeyset: Keyset(
        subscribeKey: kSubscribeKey,
        publishKey: kPublishKey,
        secretKey: kSecretKey,
        uuid: UUID(email),
      ),
    );
    final channel = pubNub.channel('Channel-1lbxtgsnm');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.ac_unit),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
//                showTrackOnHover: true,
//               controller: _scrollController,
              child: StreamBuilder(
                stream: channel.history().more().asStream(),
                builder: (BuildContext ctx, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data as FetchHistoryResult;
                    final e = data.messages.cast<Map<String, dynamic>>();
                    // for(final i in e){
                    //  print( i['message']['text']);
                    // }
                    // print('dataLength>>> $e ');
                    // print('data>>> ${snapshot.data['messages']}');
                    // return Container();
                    e.map((e) => print(e.toString()));
                    return ListView.builder(
                        itemCount: e.length,
                        // controller: _scrollController,
                        // itemCount: messages.length,
                        itemBuilder: (_, index) {
                          // final message = messages.elementAt(index);
                          // bool isMe = pubNub. == message.user;
                          return Container(
                            child: Text(e[index]['message']['text'].toString()),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    // controller: _textEditingController,
                    onSubmitted: (v) {
                      // sendMessage();
                    },
                    textInputAction: TextInputAction.send,
                    decoration: kRoundedDecorationTF.copyWith(
                      hintText: 'Enter Message',
                    ),
                  ),
                )),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: FloatingActionButton(
                    onPressed: () {},
                    mini: true,
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Directionality(
//                         textDirection:
//                             isMe ? TextDirection.ltr : TextDirection.rtl,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Align(
//                                   alignment: isMe
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                                   child: Padding(
//                                     padding: isMe
//                                         ? EdgeInsets.fromLTRB(
//                                             MediaQuery.of(context).size.width *
//                                                 .15,
//                                             10,
//                                             10,
//                                             10)
//                                         : EdgeInsets.fromLTRB(
//                                             10,
//                                             10,
//                                             MediaQuery.of(context).size.width *
//                                                 .15,
//                                             10),
//                                     child: Container(
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         borderRadius: isMe
//                                             ? BorderRadius.only(
//                                                 bottomRight:
//                                                     Radius.circular(20),
//                                                 topLeft: Radius.circular(20),
//                                                 bottomLeft: Radius.circular(20),
//                                               )
//                                             : BorderRadius.only(
//                                                 bottomLeft: Radius.circular(20),
//                                                 bottomRight:
//                                                     Radius.circular(20),
//                                                 topRight: Radius.circular(20)),
//                                         color:
//                                             isMe ? Colors.brown : Colors.grey,
//                                         boxShadow: [
//                                           BoxShadow(
//                                               color: Colors.black,
//                                               blurRadius: 2,
//                                               offset: Offset(1, 1)),
//                                         ],
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             "${message.user}",
//                                             style: TextStyle(
//                                               shadows: [
//                                                 BoxShadow(
//                                                     color: Colors.black,
//                                                     blurRadius: 2,
//                                                     offset: Offset(0, 1))
//                                               ],
//                                             ),
//                                           ),
//                                           Text(
//                                             "${message.message}",
//                                             maxLines: 20,
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )),
//                               Align(
//                                 alignment: isMe
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0),
//                                   child: Text(
//                                     "${message.date}",
//                                     style: TextStyle(
//                                         fontSize: 10.0,
//                                         color: Colors.grey[500]),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
