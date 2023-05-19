import 'package:hoodie/Models/user_management.dart';

class ChatUser {
  final String uid;
  final String avatar;
  final String displayName;

  final String lastMessage;
  final String lastMessageTime;

  ChatUser({
    required this.lastMessage,
    required this.lastMessageTime,
    required this.uid,
    required this.avatar,
    required this.displayName,
  });

  getMessageId() {
    if (UserProvider.uid.compareTo(uid) > 0) {
      return "${uid}_${UserProvider.uid}";
    } else {
      return "${UserProvider.uid}_$uid";
    }
  }
}
