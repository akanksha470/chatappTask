import 'dart:convert';
import 'dart:io';
import 'package:chatapptask/model.dart';
import 'package:chatapptask/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String friend;
  const ChatScreen(this.username, this.friend, {Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<dynamic> chatInfo = List<dynamic>();
  var _tempService = MessageService();
  bool isLoading = false;
  var user;

  getMessages() async {
    setState(() {
      isLoading = true;
    });
    user = widget.username;
    var jsonDecoded = await jsonDecode(await rootBundle.loadString('assets/data.json'));

    if(jsonDecoded.containsKey(user)) {
      var friendinfo = await jsonDecoded[user]['friends'];

      friendinfo.forEach((f) {
        var n = f.keys.elementAt(0);
        if (n == widget.friend) {
          chatInfo = f.values.elementAt(0);
          print("Chat: $chatInfo");
        }
      });
    }

    var msgs = await _tempService.readDatabySender(user, widget.friend);
    msgs.forEach((m) {
      setState(() {
        print("sender: ${m['sender']}");
        print("meesg: ${m['message']}");
//        var chatModel = Message();
//        chatModel.sender = m['sender'];
//        chatModel.message = m['message'];
//        chatInfo.add(chatModel);
      var model = {"message" : m['message'], "sender" : m['sender']};
      chatInfo.add(model);
      });
    });
    setState(() {
    isLoading = false;
    });
  }

//  Future<String> get _localPath async {
//    final directory = await getApplicationDocumentsDirectory();
//
//    return directory.path;
//  }
//  Future<File> get _localFile async {
//    final path = await _localPath;
//    return File('$path/messages.txt');
//  }
//  Future<String> readFile() async {
//    try {
//      final file = await _localFile;
//      final contents = await file.readAsString();
//      setState(() {
//        chatInfo.add(contents);
//      });
//
//      print("Contents: $contents");
//      print("Chat: $chatInfo");
//      return contents;
//    } catch (e) {
//      return "";
//    }
//  }
//  Future<File> writeFile(String message, String sender) async {
//    final file = await _localFile;
//    String text = '{"message" : $message, "sender" : $sender}';
//    return file.writeAsString(text);
//  }

  sendMessage() async{
    if(messageController.text.trim().isNotEmpty ){
      print('hello send');
//      writeFile(messageController.text.trim(), user);
//      var t = readFile();
//      print("Cont: $t");
      var m = {"message" : messageController.text.trim(), "sender" : user};
      var tempObject = Message();
      tempObject.sender = user;
      tempObject.receiver = widget.friend;
      tempObject.message = messageController.text.trim();
      var result2 = await _tempService.saveMess(tempObject);

      setState(() {
        chatInfo.add(m);
        messageController.text = "";
      });
      print("sended");
    }
  }

  Widget chatList(){
    return isLoading ? Center(child: CircularProgressIndicator(),) :
    chatInfo.length == 0 ?
    Center(child: Text("No friends", style: TextStyle(fontSize: 20),)) :
        ListView.builder(itemCount: chatInfo.length,
            itemBuilder: (context, index){
              return MessageTile(
                  chatInfo[index]["message"],
                  chatInfo[index]["sender"] == user, widget.friend, user);
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();
//    getExternalStorageDirectory().then((Directory directory) {
//      dir = directory;
//      jsonFile = new File(dir.path + "/" + fileName);
//      fileExists = jsonFile.existsSync();
//      if (fileExists) this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
          child: Text('Chat')
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Container(
        child: Stack(
          children: <Widget>[
            chatList(),
            Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                                hintText: "Type message here",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: FloatingActionButton(
                          child: Icon(Icons.send),
                          onPressed: () => sendMessage(),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message, friend, user;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe, this.friend, this.user);

  @override
  Widget build(BuildContext context) {
    print("there is messg");
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width * 0.6,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          isSendByMe ? Text(user) : Text(friend),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isSendByMe ? Colors.lightBlue : Colors.grey,
            ),
            child: Text(
              message, maxLines: 4,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
