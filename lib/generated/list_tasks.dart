part of 'hitian_connector.dart';

class ListTasksVariablesBuilder {
  Optional<String> _assigneeId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _status = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListTasksVariablesBuilder assigneeId(String? t) {
   _assigneeId.value = t;
   return this;
  }
  ListTasksVariablesBuilder status(String? t) {
   _status.value = t;
   return this;
  }

  ListTasksVariablesBuilder(this._dataConnect, );
  Deserializer<ListTasksData> dataDeserializer = (dynamic json)  => ListTasksData.fromJson(jsonDecode(json));
  Serializer<ListTasksVariables> varsSerializer = (ListTasksVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListTasksData, ListTasksVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListTasksData, ListTasksVariables> ref() {
    ListTasksVariables vars= ListTasksVariables(assigneeId: _assigneeId,status: _status,);
    return _dataConnect.query("listTasks", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListTasksTasks {
  final String id;
  final String text;
  final Timestamp deadline;
  final String status;
  final String groupId;
  final Timestamp timestamp;
  final ListTasksTasksAssignee assignee;
  final ListTasksTasksSender sender;
  ListTasksTasks.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  text = nativeFromJson<String>(json['text']),
  deadline = Timestamp.fromJson(json['deadline']),
  status = nativeFromJson<String>(json['status']),
  groupId = nativeFromJson<String>(json['groupId']),
  timestamp = Timestamp.fromJson(json['timestamp']),
  assignee = ListTasksTasksAssignee.fromJson(json['assignee']),
  sender = ListTasksTasksSender.fromJson(json['sender']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksTasks otherTyped = other as ListTasksTasks;
    return id == otherTyped.id && 
    text == otherTyped.text && 
    deadline == otherTyped.deadline && 
    status == otherTyped.status && 
    groupId == otherTyped.groupId && 
    timestamp == otherTyped.timestamp && 
    assignee == otherTyped.assignee && 
    sender == otherTyped.sender;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, text.hashCode, deadline.hashCode, status.hashCode, groupId.hashCode, timestamp.hashCode, assignee.hashCode, sender.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['text'] = nativeToJson<String>(text);
    json['deadline'] = deadline.toJson();
    json['status'] = nativeToJson<String>(status);
    json['groupId'] = nativeToJson<String>(groupId);
    json['timestamp'] = timestamp.toJson();
    json['assignee'] = assignee.toJson();
    json['sender'] = sender.toJson();
    return json;
  }

  ListTasksTasks({
    required this.id,
    required this.text,
    required this.deadline,
    required this.status,
    required this.groupId,
    required this.timestamp,
    required this.assignee,
    required this.sender,
  });
}

@immutable
class ListTasksTasksAssignee {
  final String id;
  final String name;
  ListTasksTasksAssignee.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksTasksAssignee otherTyped = other as ListTasksTasksAssignee;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  ListTasksTasksAssignee({
    required this.id,
    required this.name,
  });
}

@immutable
class ListTasksTasksSender {
  final String id;
  final String name;
  ListTasksTasksSender.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksTasksSender otherTyped = other as ListTasksTasksSender;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  ListTasksTasksSender({
    required this.id,
    required this.name,
  });
}

@immutable
class ListTasksData {
  final List<ListTasksTasks> tasks;
  ListTasksData.fromJson(dynamic json):
  
  tasks = (json['tasks'] as List<dynamic>)
        .map((e) => ListTasksTasks.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksData otherTyped = other as ListTasksData;
    return tasks == otherTyped.tasks;
    
  }
  @override
  int get hashCode => tasks.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tasks'] = tasks.map((e) => e.toJson()).toList();
    return json;
  }

  ListTasksData({
    required this.tasks,
  });
}

@immutable
class ListTasksVariables {
  late final Optional<String>assigneeId;
  late final Optional<String>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListTasksVariables.fromJson(Map<String, dynamic> json) {
  
  
    assigneeId = Optional.optional(nativeFromJson, nativeToJson);
    assigneeId.value = json['assigneeId'] == null ? null : nativeFromJson<String>(json['assigneeId']);
  
  
    status = Optional.optional(nativeFromJson, nativeToJson);
    status.value = json['status'] == null ? null : nativeFromJson<String>(json['status']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksVariables otherTyped = other as ListTasksVariables;
    return assigneeId == otherTyped.assigneeId && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([assigneeId.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(assigneeId.state == OptionalState.set) {
      json['assigneeId'] = assigneeId.toJson();
    }
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    return json;
  }

  ListTasksVariables({
    required this.assigneeId,
    required this.status,
  });
}

