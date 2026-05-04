part of 'hitian_connector.dart';

class UpsertLastReadVariablesBuilder {
  String groupId;
  String userId;

  final FirebaseDataConnect _dataConnect;
  UpsertLastReadVariablesBuilder(this._dataConnect, {required  this.groupId,required  this.userId,});
  Deserializer<UpsertLastReadData> dataDeserializer = (dynamic json)  => UpsertLastReadData.fromJson(jsonDecode(json));
  Serializer<UpsertLastReadVariables> varsSerializer = (UpsertLastReadVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertLastReadData, UpsertLastReadVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertLastReadData, UpsertLastReadVariables> ref() {
    UpsertLastReadVariables vars= UpsertLastReadVariables(groupId: groupId,userId: userId,);
    return _dataConnect.mutation("upsertLastRead", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertLastReadChatLastReadUpsert {
  final String userId;
  final String groupId;
  UpsertLastReadChatLastReadUpsert.fromJson(dynamic json):
  
  userId = nativeFromJson<String>(json['userId']),
  groupId = nativeFromJson<String>(json['groupId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertLastReadChatLastReadUpsert otherTyped = other as UpsertLastReadChatLastReadUpsert;
    return userId == otherTyped.userId && 
    groupId == otherTyped.groupId;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, groupId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['groupId'] = nativeToJson<String>(groupId);
    return json;
  }

  UpsertLastReadChatLastReadUpsert({
    required this.userId,
    required this.groupId,
  });
}

@immutable
class UpsertLastReadData {
  final UpsertLastReadChatLastReadUpsert chatLastRead_upsert;
  UpsertLastReadData.fromJson(dynamic json):
  
  chatLastRead_upsert = UpsertLastReadChatLastReadUpsert.fromJson(json['chatLastRead_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertLastReadData otherTyped = other as UpsertLastReadData;
    return chatLastRead_upsert == otherTyped.chatLastRead_upsert;
    
  }
  @override
  int get hashCode => chatLastRead_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['chatLastRead_upsert'] = chatLastRead_upsert.toJson();
    return json;
  }

  UpsertLastReadData({
    required this.chatLastRead_upsert,
  });
}

@immutable
class UpsertLastReadVariables {
  final String groupId;
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertLastReadVariables.fromJson(Map<String, dynamic> json):
  
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

    final UpsertLastReadVariables otherTyped = other as UpsertLastReadVariables;
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

  UpsertLastReadVariables({
    required this.groupId,
    required this.userId,
  });
}

