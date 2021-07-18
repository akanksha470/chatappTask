import 'package:chatapptask/connection/repository.dart';
import 'package:chatapptask/model.dart';

class MessageService {
  Repository _repository;

  MessageService() {
    _repository = Repository();
  }

  saveMess(Message m) async {
    return await _repository.insertData('chats', m.messageMap());
  }

  readDatabySender(sender, receiver) async{
    return await _repository.readDatabySender('chats', sender.toString(), receiver.toString());
  }

  readFriends(user) async{
    return await _repository.readFriends('chats', user);
  }
}