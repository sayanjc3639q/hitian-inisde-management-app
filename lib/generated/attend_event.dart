part of 'hitian_connector.dart';

class AttendEventVariablesBuilder {
  String eventId;
  String userId;

  final FirebaseDataConnect _dataConnect;
  AttendEventVariablesBuilder(this._dataConnect, {required  this.eventId,required  this.userId,});
  Deserializer<AttendEventData> dataDeserializer = (dynamic json)  => AttendEventData.fromJson(jsonDecode(json));
  Serializer<AttendEventVariables> varsSerializer = (AttendEventVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AttendEventData, AttendEventVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AttendEventData, AttendEventVariables> ref() {
    AttendEventVariables vars= AttendEventVariables(eventId: eventId,userId: userId,);
    return _dataConnect.mutation("attendEvent", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AttendEventEventAttendeeInsert {
  final String eventId;
  final String userId;
  AttendEventEventAttendeeInsert.fromJson(dynamic json):
  
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

    final AttendEventEventAttendeeInsert otherTyped = other as AttendEventEventAttendeeInsert;
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

  const AttendEventEventAttendeeInsert({
    required this.eventId,
    required this.userId,
  });
}

@immutable
class AttendEventData {
  final AttendEventEventAttendeeInsert eventAttendee_insert;
  AttendEventData.fromJson(dynamic json):
  
  eventAttendee_insert = AttendEventEventAttendeeInsert.fromJson(json['eventAttendee_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AttendEventData otherTyped = other as AttendEventData;
    return eventAttendee_insert == otherTyped.eventAttendee_insert;
    
  }
  @override
  int get hashCode => eventAttendee_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['eventAttendee_insert'] = eventAttendee_insert.toJson();
    return json;
  }

  const AttendEventData({
    required this.eventAttendee_insert,
  });
}

@immutable
class AttendEventVariables {
  final String eventId;
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AttendEventVariables.fromJson(Map<String, dynamic> json):
  
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

    final AttendEventVariables otherTyped = other as AttendEventVariables;
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

  const AttendEventVariables({
    required this.eventId,
    required this.userId,
  });
}

