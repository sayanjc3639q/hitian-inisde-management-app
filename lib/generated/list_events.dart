part of 'hitian_connector.dart';

class ListEventsVariablesBuilder {
  Optional<String> _category = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListEventsVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }

  ListEventsVariablesBuilder(this._dataConnect, );
  Deserializer<ListEventsData> dataDeserializer = (dynamic json)  => ListEventsData.fromJson(jsonDecode(json));
  Serializer<ListEventsVariables> varsSerializer = (ListEventsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListEventsData, ListEventsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListEventsData, ListEventsVariables> ref() {
    ListEventsVariables vars= ListEventsVariables(category: _category,);
    return _dataConnect.query("listEvents", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListEventsEvents {
  final String id;
  final String title;
  final String category;
  final String? location;
  final String? link;
  final Timestamp dateTime;
  final ListEventsEventsSender sender;
  final String groupId;
  final Timestamp timestamp;
  final List<ListEventsEventsAttendees> attendees;
  ListEventsEvents.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  category = nativeFromJson<String>(json['category']),
  location = json['location'] == null ? null : nativeFromJson<String>(json['location']),
  link = json['link'] == null ? null : nativeFromJson<String>(json['link']),
  dateTime = Timestamp.fromJson(json['dateTime']),
  sender = ListEventsEventsSender.fromJson(json['sender']),
  groupId = nativeFromJson<String>(json['groupId']),
  timestamp = Timestamp.fromJson(json['timestamp']),
  attendees = (json['attendees'] as List<dynamic>)
        .map((e) => ListEventsEventsAttendees.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsEvents otherTyped = other as ListEventsEvents;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    category == otherTyped.category && 
    location == otherTyped.location && 
    link == otherTyped.link && 
    dateTime == otherTyped.dateTime && 
    sender == otherTyped.sender && 
    groupId == otherTyped.groupId && 
    timestamp == otherTyped.timestamp && 
    attendees == otherTyped.attendees;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, category.hashCode, location.hashCode, link.hashCode, dateTime.hashCode, sender.hashCode, groupId.hashCode, timestamp.hashCode, attendees.hashCode]);
  

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
    json['attendees'] = attendees.map((e) => e.toJson()).toList();
    return json;
  }

  ListEventsEvents({
    required this.id,
    required this.title,
    required this.category,
    this.location,
    this.link,
    required this.dateTime,
    required this.sender,
    required this.groupId,
    required this.timestamp,
    required this.attendees,
  });
}

@immutable
class ListEventsEventsSender {
  final String id;
  final String name;
  ListEventsEventsSender.fromJson(dynamic json):
  
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

    final ListEventsEventsSender otherTyped = other as ListEventsEventsSender;
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

  ListEventsEventsSender({
    required this.id,
    required this.name,
  });
}

@immutable
class ListEventsEventsAttendees {
  final ListEventsEventsAttendeesUser user;
  ListEventsEventsAttendees.fromJson(dynamic json):
  
  user = ListEventsEventsAttendeesUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsEventsAttendees otherTyped = other as ListEventsEventsAttendees;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  ListEventsEventsAttendees({
    required this.user,
  });
}

@immutable
class ListEventsEventsAttendeesUser {
  final String id;
  final String name;
  ListEventsEventsAttendeesUser.fromJson(dynamic json):
  
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

    final ListEventsEventsAttendeesUser otherTyped = other as ListEventsEventsAttendeesUser;
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

  ListEventsEventsAttendeesUser({
    required this.id,
    required this.name,
  });
}

@immutable
class ListEventsData {
  final List<ListEventsEvents> events;
  ListEventsData.fromJson(dynamic json):
  
  events = (json['events'] as List<dynamic>)
        .map((e) => ListEventsEvents.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsData otherTyped = other as ListEventsData;
    return events == otherTyped.events;
    
  }
  @override
  int get hashCode => events.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['events'] = events.map((e) => e.toJson()).toList();
    return json;
  }

  ListEventsData({
    required this.events,
  });
}

@immutable
class ListEventsVariables {
  late final Optional<String>category;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListEventsVariables.fromJson(Map<String, dynamic> json) {
  
  
    category = Optional.optional(nativeFromJson, nativeToJson);
    category.value = json['category'] == null ? null : nativeFromJson<String>(json['category']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListEventsVariables otherTyped = other as ListEventsVariables;
    return category == otherTyped.category;
    
  }
  @override
  int get hashCode => category.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(category.state == OptionalState.set) {
      json['category'] = category.toJson();
    }
    return json;
  }

  ListEventsVariables({
    required this.category,
  });
}

