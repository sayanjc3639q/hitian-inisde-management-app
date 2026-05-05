part of 'hitian_connector.dart';

class GetLastReadVariablesBuilder {
  String groupId;
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetLastReadVariablesBuilder(this._dataConnect, {required  this.groupId,required  this.userId,});
  Deserializer<GetLastReadData> dataDeserializer = (dynamic json)  => GetLastReadData.fromJson(jsonDecode(json));
  Serializer<GetLastReadVariables> varsSerializer = (GetLastReadVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetLastReadData, GetLastReadVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetLastReadData, GetLastReadVariables> ref() {
    GetLastReadVariables vars= GetLastReadVariables(groupId: groupId,userId: userId,);
    return _dataConnect.query("getLastRead", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetLastReadChatLastRead {
  final Timestamp timestamp;
  GetLastReadChatLastRead.fromJson(dynamic json):
  
  timestamp = Timestamp.fromJson(json['timestamp']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLastReadChatLastRead otherTyped = other as GetLastReadChatLastRead;
    return timestamp == otherTyped.timestamp;
    
  }
  @override
  int get hashCode => timestamp.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['timestamp'] = timestamp.toJson();
    return json;
  }

  const GetLastReadChatLastRead({
    required this.timestamp,
  });
}

@immutable
class GetLastReadData {
  final GetLastReadChatLastRead? chatLastRead;
  GetLastReadData.fromJson(dynamic json):
  
  chatLastRead = json['chatLastRead'] == null ? null : GetLastReadChatLastRead.fromJson(json['chatLastRead']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLastReadData otherTyped = other as GetLastReadData;
    return chatLastRead == otherTyped.chatLastRead;
    
  }
  @override
  int get hashCode => chatLastRead.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (chatLastRead != null) {
      json['chatLastRead'] = chatLastRead!.toJson();
    }
    return json;
  }

  const GetLastReadData({
    this.chatLastRead,
  });
}

@immutable
class GetLastReadVariables {
  final String groupId;
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetLastReadVariables.fromJson(Map<String, dynamic> json):
  
  groupId = nativeFromJson<String>(json['groupId']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLastReadVariables otherTyped = other as GetLastReadVariables;
    return groupId == otherTyped.groupId && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([groupId.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['groupId'] = nativeToJson<String>(groupId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const GetLastReadVariables({
    required this.groupId,
    required this.userId,
  });
}

