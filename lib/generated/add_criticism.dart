part of 'hitian_connector.dart';

class AddCriticismVariablesBuilder {
  String ideaId;
  String userId;
  String content;

  final FirebaseDataConnect _dataConnect;
  AddCriticismVariablesBuilder(this._dataConnect, {required  this.ideaId,required  this.userId,required  this.content,});
  Deserializer<AddCriticismData> dataDeserializer = (dynamic json)  => AddCriticismData.fromJson(jsonDecode(json));
  Serializer<AddCriticismVariables> varsSerializer = (AddCriticismVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddCriticismData, AddCriticismVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddCriticismData, AddCriticismVariables> ref() {
    AddCriticismVariables vars= AddCriticismVariables(ideaId: ideaId,userId: userId,content: content,);
    return _dataConnect.mutation("addCriticism", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddCriticismCriticismInsert {
  final String id;
  AddCriticismCriticismInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCriticismCriticismInsert otherTyped = other as AddCriticismCriticismInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const AddCriticismCriticismInsert({
    required this.id,
  });
}

@immutable
class AddCriticismData {
  final AddCriticismCriticismInsert criticismInsert;
  AddCriticismData.fromJson(dynamic json):
  
  criticismInsert = AddCriticismCriticismInsert.fromJson(json['criticism_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCriticismData otherTyped = other as AddCriticismData;
    return criticismInsert == otherTyped.criticismInsert;
    
  }
  @override
  int get hashCode => criticismInsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['criticism_insert'] = criticismInsert.toJson();
    return json;
  }

  const AddCriticismData({
    required this.criticismInsert,
  });
}

@immutable
class AddCriticismVariables {
  final String ideaId;
  final String userId;
  final String content;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddCriticismVariables.fromJson(Map<String, dynamic> json):
  
  ideaId = nativeFromJson<String>(json['ideaId']),
  userId = nativeFromJson<String>(json['userId']),
  content = nativeFromJson<String>(json['content']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCriticismVariables otherTyped = other as AddCriticismVariables;
    return ideaId == otherTyped.ideaId && 
    userId == otherTyped.userId && 
    content == otherTyped.content;
    
  }
  @override
  int get hashCode => Object.hashAll([ideaId.hashCode, userId.hashCode, content.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ideaId'] = nativeToJson<String>(ideaId);
    json['userId'] = nativeToJson<String>(userId);
    json['content'] = nativeToJson<String>(content);
    return json;
  }

  const AddCriticismVariables({
    required this.ideaId,
    required this.userId,
    required this.content,
  });
}

