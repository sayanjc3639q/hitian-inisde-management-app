part of 'hitian_connector.dart';

class CreateTaskVariablesBuilder {
  String text;
  String assigneeId;
  String senderId;
  Timestamp deadline;
  String groupId;

  final FirebaseDataConnect _dataConnect;
  CreateTaskVariablesBuilder(this._dataConnect, {required  this.text,required  this.assigneeId,required  this.senderId,required  this.deadline,required  this.groupId,});
  Deserializer<CreateTaskData> dataDeserializer = (dynamic json)  => CreateTaskData.fromJson(jsonDecode(json));
  Serializer<CreateTaskVariables> varsSerializer = (CreateTaskVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateTaskData, CreateTaskVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateTaskData, CreateTaskVariables> ref() {
    CreateTaskVariables vars= CreateTaskVariables(text: text,assigneeId: assigneeId,senderId: senderId,deadline: deadline,groupId: groupId,);
    return _dataConnect.mutation("createTask", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateTaskTaskInsert {
  final String id;
  CreateTaskTaskInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTaskTaskInsert otherTyped = other as CreateTaskTaskInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateTaskTaskInsert({
    required this.id,
  });
}

@immutable
class CreateTaskData {
  final CreateTaskTaskInsert task_insert;
  CreateTaskData.fromJson(dynamic json):
  
  task_insert = CreateTaskTaskInsert.fromJson(json['task_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTaskData otherTyped = other as CreateTaskData;
    return task_insert == otherTyped.task_insert;
    
  }
  @override
  int get hashCode => task_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['task_insert'] = task_insert.toJson();
    return json;
  }

  CreateTaskData({
    required this.task_insert,
  });
}

@immutable
class CreateTaskVariables {
  final String text;
  final String assigneeId;
  final String senderId;
  final Timestamp deadline;
  final String groupId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateTaskVariables.fromJson(Map<String, dynamic> json):
  
  text = nativeFromJson<String>(json['text']),
  assigneeId = nativeFromJson<String>(json['assigneeId']),
  senderId = nativeFromJson<String>(json['senderId']),
  deadline = Timestamp.fromJson(json['deadline']),
  groupId = nativeFromJson<String>(json['groupId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTaskVariables otherTyped = other as CreateTaskVariables;
    return text == otherTyped.text && 
    assigneeId == otherTyped.assigneeId && 
    senderId == otherTyped.senderId && 
    deadline == otherTyped.deadline && 
    groupId == otherTyped.groupId;
    
  }
  @override
  int get hashCode => Object.hashAll([text.hashCode, assigneeId.hashCode, senderId.hashCode, deadline.hashCode, groupId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['text'] = nativeToJson<String>(text);
    json['assigneeId'] = nativeToJson<String>(assigneeId);
    json['senderId'] = nativeToJson<String>(senderId);
    json['deadline'] = deadline.toJson();
    json['groupId'] = nativeToJson<String>(groupId);
    return json;
  }

  CreateTaskVariables({
    required this.text,
    required this.assigneeId,
    required this.senderId,
    required this.deadline,
    required this.groupId,
  });
}

