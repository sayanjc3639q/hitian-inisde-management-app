part of 'hitian_connector.dart';

class UpdateIdeaStatusVariablesBuilder {
  String id;
  String status;

  final FirebaseDataConnect _dataConnect;
  UpdateIdeaStatusVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<UpdateIdeaStatusData> dataDeserializer = (dynamic json)  => UpdateIdeaStatusData.fromJson(jsonDecode(json));
  Serializer<UpdateIdeaStatusVariables> varsSerializer = (UpdateIdeaStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateIdeaStatusData, UpdateIdeaStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateIdeaStatusData, UpdateIdeaStatusVariables> ref() {
    UpdateIdeaStatusVariables vars= UpdateIdeaStatusVariables(id: id,status: status,);
    return _dataConnect.mutation("updateIdeaStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateIdeaStatusIdeaUpdate {
  final String id;
  UpdateIdeaStatusIdeaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateIdeaStatusIdeaUpdate otherTyped = other as UpdateIdeaStatusIdeaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateIdeaStatusIdeaUpdate({
    required this.id,
  });
}

@immutable
class UpdateIdeaStatusData {
  final UpdateIdeaStatusIdeaUpdate? idea_update;
  UpdateIdeaStatusData.fromJson(dynamic json):
  
  idea_update = json['idea_update'] == null ? null : UpdateIdeaStatusIdeaUpdate.fromJson(json['idea_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateIdeaStatusData otherTyped = other as UpdateIdeaStatusData;
    return idea_update == otherTyped.idea_update;
    
  }
  @override
  int get hashCode => idea_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (idea_update != null) {
      json['idea_update'] = idea_update!.toJson();
    }
    return json;
  }

  UpdateIdeaStatusData({
    this.idea_update,
  });
}

@immutable
class UpdateIdeaStatusVariables {
  final String id;
  final String status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateIdeaStatusVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  status = nativeFromJson<String>(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateIdeaStatusVariables otherTyped = other as UpdateIdeaStatusVariables;
    return id == otherTyped.id && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = nativeToJson<String>(status);
    return json;
  }

  UpdateIdeaStatusVariables({
    required this.id,
    required this.status,
  });
}

