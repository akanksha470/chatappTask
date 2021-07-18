import 'dart:convert';

import 'package:chatapptask/screens/Chat.dart';
import 'package:chatapptask/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Messages extends StatefulWidget {
  final String username;
  const Messages(this.username, {Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  List<String> friendsList = List<String>();
  var _tempService = MessageService();
  bool isLoading = false;
  var name, flag;

  Future<String> loadAsset() async {
    print("hi");
    setState(() {
      isLoading = true;
    });
    name = widget.username;
    print("name: $name");
    var jsonDecoded = await jsonDecode(await rootBundle.loadString('assets/data.json'));
    if(jsonDecoded.containsKey(name)) {
      var friendinfo = await jsonDecoded[name]['friends'];

      friendinfo.forEach((f) {
        var n = f.keys.elementAt(0);
        friendsList.add(n);
      });
    }

      var friends = await _tempService.readFriends(name);
      print("Friends  $friends");
      friends.forEach((f){
        print("f : $f");
        var friend;
        if(f['sender'] == name){
          friend = f['receiver'];
        }
        else{
          friend = f['sender'];
        }
        setState(() {
          for(var i = 0; i < friendsList.length; i = i + 1){
            if(friendsList[i] == friend){
              flag = 1;
              break;
            }
          }
          if(flag == 0) {
            friendsList.add(friend);
          }
        });
      });
      print("Friends: $friendsList");

    setState(() {
      isLoading = false;
    });
  }
  //List<dynamic> response = loadAsset() as List;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flag = 0;
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Color(0xFF071A3F),
      appBar: AppBar(
        title: Center(child: Text('Messages')),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) :
      friendsList.length == 0 ?
            Center(child: Text("No friends", style: TextStyle(fontSize: 20),)) :
            ListView.builder(
              itemCount: friendsList.length,
              itemBuilder: (context, index){
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 20),
                    child: Card(
                      elevation: 5,
                      color: Color(0xFF071A3F),
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.indigoAccent),
                            child: Center(
                              child:
                              Text(friendsList[index].substring(0, 1).toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 24))

                            ),
                          ),
                        ),
                        title: Text(friendsList[index], style: TextStyle(color: Colors.white)),
                        trailing: GestureDetector(
                            child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(name, friendsList[index]))),
                        ),
                      ),
                    ),
                  ),
                ],
              );
              },

      )
    );
  }
}
