class Message{
  String sender, receiver, message;

  messageMap() {
    var mapping = Map<String, dynamic>();
    mapping['sender'] = sender;
    mapping['receiver'] = receiver;
    mapping['message'] = message;

    return mapping;
  }
}