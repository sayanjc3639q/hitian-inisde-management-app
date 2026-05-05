part of 'hitian_connector.dart';

class AddReactionVariablesBuilder {
  String messageId;
  String userId;
  String emoji;

  final FirebaseDataConnect _dataConnect;
  AddReactionVariablesBuilder(this._dataConnect, {required  this.messageId,required  this.userId,required  this.emoji,});
  Deserializer<AddReactionData> dataDeserializer = (dynamic json)  => AddReactionData.fromJson(jsonDecode(json));
  Serializer<AddReactionVariables> varsSerializer = (AddReactionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddReactionData, AddReactionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddReactionData, AddReactionVariables> ref() {
    AddReactionVariables vars= AddReactionVariables(messageId: messageId,userId: userId,emoji: emoji,);
    return _dataConnect.mutation("addReaction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddReactionMessageReactionUpsert {
  final String messageId;
  final String userId;
  AddReactionMessageReactionUpsert.fromJson(dynamic json):
  
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

    final AddReactionMessageReactionUpsert otherTyped = other as AddReactionMessageReactionUpsert;
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

  const AddReactionMessageReactionUpsert({
    required this.messageId,
    required this.userId,
  });
}

@immutable
class AddReactionData {
  final AddReactionMessageReactionUpsert messageReactionUpsert;
  AddReactionData.fromJson(dynamic json):
  
  messageReactionUpsert = AddReactionMessageReactionUpsert.fromJson(json['messageReaction_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddReactionData otherTyped = other as AddReactionData;
    return messageReactionUpsert == otherTyped.messageReactionUpsert;
    
  }
  @override
  int get hashCode => messageReactionUpsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messageReaction_upsert'] = messageReactionUpsert.toJson();
    return json;
  }

  const AddReactionData({
    required this.messageReactionUpsert,
  });
}

@immutable
class AddReactionVariables {
  final String messageId;
  final String userId;
  final String emoji;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddReactionVariables.fromJson(Map<String, dynamic> json):
  
  messageId = nativeFromJson<String>(json['messageId']),
  userId = nativeFromJson<String>(json['userId']),
  emoji = nativeFromJson<String>(json['emoji']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddReactionVariables otherTyped = other as AddReactionVariables;
    return messageId == otherTyped.messageId && 
    userId == otherTyped.userId && 
    emoji == otherTyped.emoji;
    
  }
  @override
  int get hashCode => Object.hashAll([messageId.hashCode, userId.hashCode, emoji.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messageId'] = nativeToJson<String>(messageId);
    json['userId'] = nativeToJson<String>(userId);
    json['emoji'] = nativeToJson<String>(emoji);
    return json;
  }

  const AddReactionVariables({
    required this.messageId,
    required this.userId,
    required this.emoji,
  });
}

