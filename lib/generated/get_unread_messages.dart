part of 'hitian_connector.dart';

class GetUnreadMessagesVariablesBuilder {
  String groupId;
  Timestamp lastRead;

  final FirebaseDataConnect _dataConnect;
  GetUnreadMessagesVariablesBuilder(this._dataConnect, {required  this.groupId,required  this.lastRead,});
  Deserializer<GetUnreadMessagesData> dataDeserializer = (dynamic json)  => GetUnreadMessagesData.fromJson(jsonDecode(json));
  Serializer<GetUnreadMessagesVariables> varsSerializer = (GetUnreadMessagesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUnreadMessagesData, GetUnreadMessagesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUnreadMessagesData, GetUnreadMessagesVariables> ref() {
    GetUnreadMessagesVariables vars= GetUnreadMessagesVariables(groupId: groupId,lastRead: lastRead,);
    return _dataConnect.query("getUnreadMessages", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUnreadMessagesMessages {
  final String id;
  final String senderId;
  GetUnreadMessagesMessages.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  senderId = nativeFromJson<String>(json['senderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUnreadMessagesMessages otherTyped = other as GetUnreadMessagesMessages;
    return id == otherTyped.id && 
    senderId == otherTyped.senderId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, senderId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['senderId'] = nativeToJson<String>(senderId);
    return json;
  }

  GetUnreadMessagesMessages({
    required this.id,
    required this.senderId,
  });
}

@immutable
class GetUnreadMessagesData {
  final List<GetUnreadMessagesMessages> messages;
  GetUnreadMessagesData.fromJson(dynamic json):
  
  messages = (json['messages'] as List<dynamic>)
        .map((e) => GetUnreadMessagesMessages.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUnreadMessagesData otherTyped = other as GetUnreadMessagesData;
    return messages == otherTyped.messages;
    
  }
  @override
  int get hashCode => messages.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messages'] = messages.map((e) => e.toJson()).toList();
    return json;
  }

  GetUnreadMessagesData({
    required this.messages,
  });
}

@immutable
class GetUnreadMessagesVariables {
  final String groupId;
  final Timestamp lastRead;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUnreadMessagesVariables.fromJson(Map<String, dynamic> json):
  
  groupId = nativeFromJson<String>(json['groupId']),
  lastRead = Timestamp.fromJson(json['lastRead']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUnreadMessagesVariables otherTyped = other as GetUnreadMessagesVariables;
    return groupId == otherTyped.groupId && 
    lastRead == otherTyped.lastRead;
    
  }
  @override
  int get hashCode => Object.hashAll([groupId.hashCode, lastRead.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['groupId'] = nativeToJson<String>(groupId);
    json['lastRead'] = lastRead.toJson();
    return json;
  }

  GetUnreadMessagesVariables({
    required this.groupId,
    required this.lastRead,
  });
}

