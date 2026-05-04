part of 'hitian_connector.dart';

class DeleteIdeaVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteIdeaVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteIdeaData> dataDeserializer = (dynamic json)  => DeleteIdeaData.fromJson(jsonDecode(json));
  Serializer<DeleteIdeaVariables> varsSerializer = (DeleteIdeaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteIdeaData, DeleteIdeaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteIdeaData, DeleteIdeaVariables> ref() {
    DeleteIdeaVariables vars= DeleteIdeaVariables(id: id,);
    return _dataConnect.mutation("deleteIdea", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteIdeaIdeaDelete {
  final String id;
  DeleteIdeaIdeaDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteIdeaIdeaDelete otherTyped = other as DeleteIdeaIdeaDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteIdeaIdeaDelete({
    required this.id,
  });
}

@immutable
class DeleteIdeaData {
  final DeleteIdeaIdeaDelete? idea_delete;
  DeleteIdeaData.fromJson(dynamic json):
  
  idea_delete = json['idea_delete'] == null ? null : DeleteIdeaIdeaDelete.fromJson(json['idea_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteIdeaData otherTyped = other as DeleteIdeaData;
    return idea_delete == otherTyped.idea_delete;
    
  }
  @override
  int get hashCode => idea_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (idea_delete != null) {
      json['idea_delete'] = idea_delete!.toJson();
    }
    return json;
  }

  DeleteIdeaData({
    this.idea_delete,
  });
}

@immutable
class DeleteIdeaVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteIdeaVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteIdeaVariables otherTyped = other as DeleteIdeaVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteIdeaVariables({
    required this.id,
  });
}

