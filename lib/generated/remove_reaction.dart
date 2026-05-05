part of 'hitian_connector.dart';

class RemoveReactionVariablesBuilder {
  String messageId;
  String userId;

  final FirebaseDataConnect _dataConnect;
  RemoveReactionVariablesBuilder(this._dataConnect, {required  this.messageId,required  this.userId,});
  Deserializer<RemoveReactionData> dataDeserializer = (dynamic json)  => RemoveReactionData.fromJson(jsonDecode(json));
  Serializer<RemoveReactionVariables> varsSerializer = (RemoveReactionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RemoveReactionData, RemoveReactionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RemoveReactionData, RemoveReactionVariables> ref() {
    RemoveReactionVariables vars= RemoveReactionVariables(messageId: messageId,userId: userId,);
    return _dataConnect.mutation("removeReaction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RemoveReactionMessageReactionDelete {
  final String messageId;
  final String userId;
  RemoveReactionMessageReactionDelete.fromJson(dynamic json):
  
  messageId = nativeFromJson<String>(json['messageId']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveReactionMessageReactionDelete otherTyped = other as RemoveReactionMessageReactionDelete;
    return messageId == otherTyped.messageId && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([messageId.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messageId'] = nativeToJson<String>(messageId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const RemoveReactionMessageReactionDelete({
    required this.messageId,
    required this.userId,
  });
}

@immutable
class RemoveReactionData {
  final RemoveReactionMessageReactionDelete? messageReaction_delete;
  RemoveReactionData.fromJson(dynamic json):
  
  messageReaction_delete = json['messageReaction_delete'] == null ? null : RemoveReactionMessageReactionDelete.fromJson(json['messageReaction_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveReactionData otherTyped = other as RemoveReactionData;
    return messageReaction_delete == otherTyped.messageReaction_delete;
    
  }
  @override
  int get hashCode => messageReaction_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (messageReaction_delete != null) {
      json['messageReaction_delete'] = messageReaction_delete!.toJson();
    }
    return json;
  }

  const RemoveReactionData({
    this.messageReaction_delete,
  });
}

@immutable
class RemoveReactionVariables {
  final String messageId;
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RemoveReactionVariables.fromJson(Map<String, dynamic> json):
  
  messageId = nativeFromJson<String>(json['messageId']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveReactionVariables otherTyped = other as RemoveReactionVariables;
    return messageId == otherTyped.messageId && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([messageId.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messageId'] = nativeToJson<String>(messageId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const RemoveReactionVariables({
    required this.messageId,
    required this.userId,
  });
}

