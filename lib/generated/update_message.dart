part of 'hitian_connector.dart';

class UpdateMessageVariablesBuilder {
  String id;
  String text;
  Optional<String> _metadata = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateMessageVariablesBuilder metadata(String? t) {
   _metadata.value = t;
   return this;
  }

  UpdateMessageVariablesBuilder(this._dataConnect, {required  this.id,required  this.text,});
  Deserializer<UpdateMessageData> dataDeserializer = (dynamic json)  => UpdateMessageData.fromJson(jsonDecode(json));
  Serializer<UpdateMessageVariables> varsSerializer = (UpdateMessageVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMessageData, UpdateMessageVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateMessageData, UpdateMessageVariables> ref() {
    UpdateMessageVariables vars= UpdateMessageVariables(id: id,text: text,metadata: _metadata,);
    return _dataConnect.mutation("updateMessage", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateMessageMessageUpdate {
  final String id;
  UpdateMessageMessageUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMessageMessageUpdate otherTyped = other as UpdateMessageMessageUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateMessageMessageUpdate({
    required this.id,
  });
}

@immutable
class UpdateMessageData {
  final UpdateMessageMessageUpdate? message_update;
  UpdateMessageData.fromJson(dynamic json):
  
  message_update = json['message_update'] == null ? null : UpdateMessageMessageUpdate.fromJson(json['message_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMessageData otherTyped = other as UpdateMessageData;
    return message_update == otherTyped.message_update;
    
  }
  @override
  int get hashCode => message_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (message_update != null) {
      json['message_update'] = message_update!.toJson();
    }
    return json;
  }

  UpdateMessageData({
    this.message_update,
  });
}

@immutable
class UpdateMessageVariables {
  final String id;
  final String text;
  late final Optional<String>metadata;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateMessageVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  text = nativeFromJson<String>(json['text']) {
  
  
  
  
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

    final UpdateMessageVariables otherTyped = other as UpdateMessageVariables;
    return id == otherTyped.id && 
    text == otherTyped.text && 
    metadata == otherTyped.metadata;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, text.hashCode, metadata.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['text'] = nativeToJson<String>(text);
    if(metadata.state == OptionalState.set) {
      json['metadata'] = metadata.toJson();
    }
    return json;
  }

  UpdateMessageVariables({
    required this.id,
    required this.text,
    required this.metadata,
  });
}

