part of 'hitian_connector.dart';

class CreateEventVariablesBuilder {
  String title;
  String category;
  final Optional<String> _location = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _link = Optional.optional(nativeFromJson, nativeToJson);
  Timestamp dateTime;
  String senderId;
  String groupId;

  final FirebaseDataConnect _dataConnect;  CreateEventVariablesBuilder location(String? t) {
   _location.value = t;
   return this;
  }
  CreateEventVariablesBuilder link(String? t) {
   _link.value = t;
   return this;
  }

  CreateEventVariablesBuilder(this._dataConnect, {required  this.title,required  this.category,required  this.dateTime,required  this.senderId,required  this.groupId,});
  Deserializer<CreateEventData> dataDeserializer = (dynamic json)  => CreateEventData.fromJson(jsonDecode(json));
  Serializer<CreateEventVariables> varsSerializer = (CreateEventVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateEventData, CreateEventVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateEventData, CreateEventVariables> ref() {
    CreateEventVariables vars= CreateEventVariables(title: title,category: category,location: _location,link: _link,dateTime: dateTime,senderId: senderId,groupId: groupId,);
    return _dataConnect.mutation("createEvent", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateEventEventInsert {
  final String id;
  CreateEventEventInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateEventEventInsert otherTyped = other as CreateEventEventInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateEventEventInsert({
    required this.id,
  });
}

class CreateEventData {
  final CreateEventEventInsert eventInsert;
  CreateEventData.fromJson(dynamic json):
  
  eventInsert = CreateEventEventInsert.fromJson(json['event_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateEventData otherTyped = other as CreateEventData;
    return eventInsert == otherTyped.eventInsert;
    
  }
  @override
  int get hashCode => eventInsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['event_insert'] = eventInsert.toJson();
    return json;
  }

  CreateEventData({
    required this.eventInsert,
  });
}

class CreateEventVariables {
  final String title;
  final String category;
  late final Optional<String>location;
  late final Optional<String>link;
  final Timestamp dateTime;
  final String senderId;
  final String groupId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateEventVariables.fromJson(Map<String, dynamic> json):
  
  title = nativeFromJson<String>(json['title']),
  category = nativeFromJson<String>(json['category']),
  dateTime = Timestamp.fromJson(json['dateTime']),
  senderId = nativeFromJson<String>(json['senderId']),
  groupId = nativeFromJson<String>(json['groupId']) {
  
  
  
  
    location = Optional.optional(nativeFromJson, nativeToJson);
    location.value = json['location'] == null ? null : nativeFromJson<String>(json['location']);
  
  
    link = Optional.optional(nativeFromJson, nativeToJson);
    link.value = json['link'] == null ? null : nativeFromJson<String>(json['link']);
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateEventVariables otherTyped = other as CreateEventVariables;
    return title == otherTyped.title && 
    category == otherTyped.category && 
    location == otherTyped.location && 
    link == otherTyped.link && 
    dateTime == otherTyped.dateTime && 
    senderId == otherTyped.senderId && 
    groupId == otherTyped.groupId;
    
  }
  @override
  int get hashCode => Object.hashAll([title.hashCode, category.hashCode, location.hashCode, link.hashCode, dateTime.hashCode, senderId.hashCode, groupId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['category'] = nativeToJson<String>(category);
    if(location.state == OptionalState.set) {
      json['location'] = location.toJson();
    }
    if(link.state == OptionalState.set) {
      json['link'] = link.toJson();
    }
    json['dateTime'] = dateTime.toJson();
    json['senderId'] = nativeToJson<String>(senderId);
    json['groupId'] = nativeToJson<String>(groupId);
    return json;
  }

  CreateEventVariables({
    required this.title,
    required this.category,
    required this.location,
    required this.link,
    required this.dateTime,
    required this.senderId,
    required this.groupId,
  });
}

