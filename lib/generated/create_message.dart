part of 'hitian_connector.dart';

class CreateMessageVariablesBuilder {
  String groupId;
  String senderId;
  String text;
  Optional<String> _type = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _metadata = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateMessageVariablesBuilder type(String? t) {
   _type.value = t;
   return this;
  }
  CreateMessageVariablesBuilder metadata(String? t) {
   _metadata.value = t;
   return this;
  }

  CreateMessageVariablesBuilder(this._dataConnect, {required  this.groupId,required  this.senderId,required  this.text,});
  Deserializer<CreateMessageData> dataDeserializer = (dynamic json)  => CreateMessageData.fromJson(jsonDecode(json));
  Serializer<CreateMessageVariables> varsSerializer = (CreateMessageVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateMessageData, CreateMessageVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateMessageData, CreateMessageVariables> ref() {
    CreateMessageVariables vars= CreateMessageVariables(groupId: groupId,senderId: senderId,text: text,type: _type,metadata: _metadata,);
    return _dataConnect.mutation("createMessage", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateMessageMessageInsert {
  final String id;
  CreateMessageMessageInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMessageMessageInsert otherTyped = other as CreateMessageMessageInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateMessageMessageInsert({
    required this.id,
  });
}

@immutable
class CreateMessageData {
  final CreateMessageMessageInsert message_insert;
  CreateMessageData.fromJson(dynamic json):
  
  message_insert = CreateMessageMessageInsert.fromJson(json['message_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMessageData otherTyped = other as CreateMessageData;
    return message_insert == otherTyped.message_insert;
    
  }
  @override
  int get hashCode => message_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['message_insert'] = message_insert.toJson();
    return json;
  }

  CreateMessageData({
    required this.message_insert,
  });
}

@immutable
class CreateMessageVariables {
  final String groupId;
  final String senderId;
  final String text;
  late final Optional<String>type;
  late final Optional<String>metadata;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateMessageVariables.fromJson(Map<String, dynamic> json):
  
  groupId = nativeFromJson<String>(json['groupId']),
  senderId = nativeFromJson<String>(json['senderId']),
  text = nativeFromJson<String>(json['text']) {
  
  
  
  
  
    type = Optional.optional(nativeFromJson, nativeToJson);
    type.value = json['type'] == null ? null : nativeFromJson<String>(json['type']);
  
  
    metadata = Optional.optional(nativeFromJson, nativeToJson);
    metadata.value = json['metadata'] == null ? null : nativeFromJson<String>(json['metadata']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMessageVariables otherTyped = other as CreateMessageVariables;
    return groupId == otherTyped.groupId && 
    senderId == otherTyped.senderId && 
    text == otherTyped.text && 
    type == otherTyped.type && 
    metadata == otherTyped.metadata;
    
  }
  @override
  int get hashCode => Object.hashAll([groupId.hashCode, senderId.hashCode, text.hashCode, type.hashCode, metadata.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['groupId'] = nativeToJson<String>(groupId);
    json['senderId'] = nativeToJson<String>(senderId);
    json['text'] = nativeToJson<String>(text);
    if(type.state == OptionalState.set) {
      json['type'] = type.toJson();
    }
    if(metadata.state == OptionalState.set) {
      json['metadata'] = metadata.toJson();
    }
    return json;
  }

  CreateMessageVariables({
    required this.groupId,
    required this.senderId,
    required this.text,
    required this.type,
    required this.metadata,
  });
}

