part of 'hitian_connector.dart';

class ListEventsByAttendeeVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  ListEventsByAttendeeVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<ListEventsByAttendeeData> dataDeserializer = (dynamic json)  => ListEventsByAttendeeData.fromJson(jsonDecode(json));
  Serializer<ListEventsByAttendeeVariables> varsSerializer = (ListEventsByAttendeeVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListEventsByAttendeeData, ListEventsByAttendeeVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListEventsByAttendeeData, ListEventsByAttendeeVariables> ref() {
    ListEventsByAttendeeVariables vars= ListEventsByAttendeeVariables(userId: userId,);
    return _dataConnect.query("listEventsByAttendee", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListEventsByAttendeeEventAttendees {
  final ListEventsByAttendeeEventAttendeesEvent event;
  ListEventsByAttendeeEventAttendees.fromJson(dynamic json):
  
  event = ListEventsByAttendeeEventAttendeesEvent.fromJson(json['event']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsByAttendeeEventAttendees otherTyped = other as ListEventsByAttendeeEventAttendees;
    return event == otherTyped.event;
    
  }
  @override
  int get hashCode => event.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['event'] = event.toJson();
    return json;
  }

  ListEventsByAttendeeEventAttendees({
    required this.event,
  });
}

@immutable
class ListEventsByAttendeeEventAttendeesEvent {
  final String id;
  final String title;
  final String? location;
  final String? link;
  final Timestamp dateTime;
  final String groupId;
  final Timestamp timestamp;
  ListEventsByAttendeeEventAttendeesEvent.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  location = json['location'] == null ? null : nativeFromJson<String>(json['location']),
  link = json['link'] == null ? null : nativeFromJson<String>(json['link']),
  dateTime = Timestamp.fromJson(json['dateTime']),
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

    final ListEventsByAttendeeEventAttendeesEvent otherTyped = other as ListEventsByAttendeeEventAttendeesEvent;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    location == otherTyped.location && 
    link == otherTyped.link && 
    dateTime == otherTyped.dateTime && 
    groupId == otherTyped.groupId && 
    timestamp == otherTyped.timestamp;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, location.hashCode, link.hashCode, dateTime.hashCode, groupId.hashCode, timestamp.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    if (location != null) {
      json['location'] = nativeToJson<String?>(location);
    }
    if (link != null) {
      json['link'] = nativeToJson<String?>(link);
    }
    json['dateTime'] = dateTime.toJson();
    json['groupId'] = nativeToJson<String>(groupId);
    json['timestamp'] = timestamp.toJson();
    return json;
  }

  ListEventsByAttendeeEventAttendeesEvent({
    required this.id,
    required this.title,
    this.location,
    this.link,
    required this.dateTime,
    required this.groupId,
    required this.timestamp,
  });
}

@immutable
class ListEventsByAttendeeData {
  final List<ListEventsByAttendeeEventAttendees> eventAttendees;
  ListEventsByAttendeeData.fromJson(dynamic json):
  
  eventAttendees = (json['eventAttendees'] as List<dynamic>)
        .map((e) => ListEventsByAttendeeEventAttendees.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsByAttendeeData otherTyped = other as ListEventsByAttendeeData;
    return eventAttendees == otherTyped.eventAttendees;
    
  }
  @override
  int get hashCode => eventAttendees.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['eventAttendees'] = eventAttendees.map((e) => e.toJson()).toList();
    return json;
  }

  ListEventsByAttendeeData({
    required this.eventAttendees,
  });
}

@immutable
class ListEventsByAttendeeVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListEventsByAttendeeVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsByAttendeeVariables otherTyped = other as ListEventsByAttendeeVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  ListEventsByAttendeeVariables({
    required this.userId,
  });
}

