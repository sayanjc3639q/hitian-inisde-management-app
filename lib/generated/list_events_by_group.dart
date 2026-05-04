part of 'hitian_connector.dart';

class ListEventsByGroupVariablesBuilder {
  Optional<List<String>> _groupIds = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));

  final FirebaseDataConnect _dataConnect;
  ListEventsByGroupVariablesBuilder groupIds(List<String>? t) {
   _groupIds.value = t;
   return this;
  }

  ListEventsByGroupVariablesBuilder(this._dataConnect, );
  Deserializer<ListEventsByGroupData> dataDeserializer = (dynamic json)  => ListEventsByGroupData.fromJson(jsonDecode(json));
  Serializer<ListEventsByGroupVariables> varsSerializer = (ListEventsByGroupVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListEventsByGroupData, ListEventsByGroupVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListEventsByGroupData, ListEventsByGroupVariables> ref() {
    ListEventsByGroupVariables vars= ListEventsByGroupVariables(groupIds: _groupIds,);
    return _dataConnect.query("listEventsByGroup", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListEventsByGroupEvents {
  final String id;
  final String title;
  final String category;
  final String? location;
  final String? link;
  final Timestamp dateTime;
  final ListEventsByGroupEventsSender sender;
  final String groupId;
  final Timestamp timestamp;
  ListEventsByGroupEvents.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  category = nativeFromJson<String>(json['category']),
  location = json['location'] == null ? null : nativeFromJson<String>(json['location']),
  link = json['link'] == null ? null : nativeFromJson<String>(json['link']),
  dateTime = Timestamp.fromJson(json['dateTime']),
  sender = ListEventsByGroupEventsSender.fromJson(json['sender']),
  groupId = nativeFromJson<String>(json['groupId']),
  timestamp = Timestamp.fromJson(json['timestamp']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsByGroupEvents otherTyped = other as ListEventsByGroupEvents;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    category == otherTyped.category && 
    location == otherTyped.location && 
    link == otherTyped.link && 
    dateTime == otherTyped.dateTime && 
    sender == otherTyped.sender && 
    groupId == otherTyped.groupId && 
    timestamp == otherTyped.timestamp;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, category.hashCode, location.hashCode, link.hashCode, dateTime.hashCode, sender.hashCode, groupId.hashCode, timestamp.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['category'] = nativeToJson<String>(category);
    if (location != null) {
      json['location'] = nativeToJson<String?>(location);
    }
    if (link != null) {
      json['link'] = nativeToJson<String?>(link);
    }
    json['dateTime'] = dateTime.toJson();
    json['sender'] = sender.toJson();
    json['groupId'] = nativeToJson<String>(groupId);
    json['timestamp'] = timestamp.toJson();
    return json;
  }

  ListEventsByGroupEvents({
    required this.id,
    required this.title,
    required this.category,
    this.location,
    this.link,
    required this.dateTime,
    required this.sender,
    required this.groupId,
    required this.timestamp,
  });
}

@immutable
class ListEventsByGroupEventsSender {
  final String id;
  final String name;
  ListEventsByGroupEventsSender.fromJson(dynamic json):
  
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

    final ListEventsByGroupEventsSender otherTyped = other as ListEventsByGroupEventsSender;
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

  ListEventsByGroupEventsSender({
    required this.id,
    required this.name,
  });
}

@immutable
class ListEventsByGroupData {
  final List<ListEventsByGroupEvents> events;
  ListEventsByGroupData.fromJson(dynamic json):
  
  events = (json['events'] as List<dynamic>)
        .map((e) => ListEventsByGroupEvents.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsByGroupData otherTyped = other as ListEventsByGroupData;
    return events == otherTyped.events;
    
  }
  @override
  int get hashCode => events.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['events'] = events.map((e) => e.toJson()).toList();
    return json;
  }

  ListEventsByGroupData({
    required this.events,
  });
}

@immutable
class ListEventsByGroupVariables {
  late final Optional<List<String>>groupIds;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListEventsByGroupVariables.fromJson(Map<String, dynamic> json) {
  
  
    groupIds = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
    groupIds.value = json['groupIds'] == null ? null : (json['groupIds'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsByGroupVariables otherTyped = other as ListEventsByGroupVariables;
    return groupIds == otherTyped.groupIds;
    
  }
  @override
  int get hashCode => groupIds.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(groupIds.state == OptionalState.set) {
      json['groupIds'] = groupIds.toJson();
    }
    return json;
  }

  ListEventsByGroupVariables({
    required this.groupIds,
  });
}

