part of 'hitian_connector.dart';

class UnattendEventVariablesBuilder {
  String eventId;
  String userId;

  final FirebaseDataConnect _dataConnect;
  UnattendEventVariablesBuilder(this._dataConnect, {required  this.eventId,required  this.userId,});
  Deserializer<UnattendEventData> dataDeserializer = (dynamic json)  => UnattendEventData.fromJson(jsonDecode(json));
  Serializer<UnattendEventVariables> varsSerializer = (UnattendEventVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UnattendEventData, UnattendEventVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UnattendEventData, UnattendEventVariables> ref() {
    UnattendEventVariables vars= UnattendEventVariables(eventId: eventId,userId: userId,);
    return _dataConnect.mutation("unattendEvent", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UnattendEventEventAttendeeDelete {
  final String eventId;
  final String userId;
  UnattendEventEventAttendeeDelete.fromJson(dynamic json):
  
  eventId = nativeFromJson<String>(json['eventId']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UnattendEventEventAttendeeDelete otherTyped = other as UnattendEventEventAttendeeDelete;
    return eventId == otherTyped.eventId && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([eventId.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['eventId'] = nativeToJson<String>(eventId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  UnattendEventEventAttendeeDelete({
    required this.eventId,
    required this.userId,
  });
}

@immutable
class UnattendEventData {
  final UnattendEventEventAttendeeDelete? eventAttendee_delete;
  UnattendEventData.fromJson(dynamic json):
  
  eventAttendee_delete = json['eventAttendee_delete'] == null ? null : UnattendEventEventAttendeeDelete.fromJson(json['eventAttendee_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UnattendEventData otherTyped = other as UnattendEventData;
    return eventAttendee_delete == otherTyped.eventAttendee_delete;
    
  }
  @override
  int get hashCode => eventAttendee_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (eventAttendee_delete != null) {
      json['eventAttendee_delete'] = eventAttendee_delete!.toJson();
    }
    return json;
  }

  UnattendEventData({
    this.eventAttendee_delete,
  });
}

@immutable
class UnattendEventVariables {
  final String eventId;
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UnattendEventVariables.fromJson(Map<String, dynamic> json):
  
  eventId = nativeFromJson<String>(json['eventId']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UnattendEventVariables otherTyped = other as UnattendEventVariables;
    return eventId == otherTyped.eventId && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([eventId.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['eventId'] = nativeToJson<String>(eventId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  UnattendEventVariables({
    required this.eventId,
    required this.userId,
  });
}

