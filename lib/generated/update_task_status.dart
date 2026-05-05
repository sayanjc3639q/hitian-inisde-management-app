part of 'hitian_connector.dart';

class UpdateTaskStatusVariablesBuilder {
  String id;
  String status;
  final Optional<Timestamp> _timestamp = Optional.optional((json) => json['timestamp'] = Timestamp.fromJson(json['timestamp']), defaultSerializer);

  final FirebaseDataConnect _dataConnect;  UpdateTaskStatusVariablesBuilder timestamp(Timestamp? t) {
   _timestamp.value = t;
   return this;
  }

  UpdateTaskStatusVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<UpdateTaskStatusData> dataDeserializer = (dynamic json)  => UpdateTaskStatusData.fromJson(jsonDecode(json));
  Serializer<UpdateTaskStatusVariables> varsSerializer = (UpdateTaskStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateTaskStatusData, UpdateTaskStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateTaskStatusData, UpdateTaskStatusVariables> ref() {
    UpdateTaskStatusVariables vars= UpdateTaskStatusVariables(id: id,status: status,timestamp: _timestamp,);
    return _dataConnect.mutation("updateTaskStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateTaskStatusTaskUpdate {
  final String id;
  UpdateTaskStatusTaskUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskStatusTaskUpdate otherTyped = other as UpdateTaskStatusTaskUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateTaskStatusTaskUpdate({
    required this.id,
  });
}

@immutable
class UpdateTaskStatusData {
  final UpdateTaskStatusTaskUpdate? taskUpdate;
  UpdateTaskStatusData.fromJson(dynamic json):
  
  taskUpdate = json['task_update'] == null ? null : UpdateTaskStatusTaskUpdate.fromJson(json['task_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskStatusData otherTyped = other as UpdateTaskStatusData;
    return taskUpdate == otherTyped.taskUpdate;
    
  }
  @override
  int get hashCode => taskUpdate.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (taskUpdate != null) {
      json['task_update'] = taskUpdate!.toJson();
    }
    return json;
  }

  const UpdateTaskStatusData({
    this.taskUpdate,
  });
}

class UpdateTaskStatusVariables {
  final String id;
  final String status;
  late final Optional<Timestamp>timestamp;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateTaskStatusVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  status = nativeFromJson<String>(json['status']) {
  
  
  
  
    timestamp = Optional.optional((json) => json['timestamp'] = Timestamp.fromJson(json['timestamp']), defaultSerializer);
    timestamp.value = json['timestamp'] == null ? null : Timestamp.fromJson(json['timestamp']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskStatusVariables otherTyped = other as UpdateTaskStatusVariables;
    return id == otherTyped.id && 
    status == otherTyped.status && 
    timestamp == otherTyped.timestamp;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode, timestamp.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = nativeToJson<String>(status);
    if(timestamp.state == OptionalState.set) {
      json['timestamp'] = timestamp.toJson();
    }
    return json;
  }

  UpdateTaskStatusVariables({
    required this.id,
    required this.status,
    required this.timestamp,
  });
}

