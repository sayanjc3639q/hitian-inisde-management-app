part of 'hitian_connector.dart';

class VoteIdeaVariablesBuilder {
  String ideaId;
  String userId;
  String type;

  final FirebaseDataConnect _dataConnect;
  VoteIdeaVariablesBuilder(this._dataConnect, {required  this.ideaId,required  this.userId,required  this.type,});
  Deserializer<VoteIdeaData> dataDeserializer = (dynamic json)  => VoteIdeaData.fromJson(jsonDecode(json));
  Serializer<VoteIdeaVariables> varsSerializer = (VoteIdeaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<VoteIdeaData, VoteIdeaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<VoteIdeaData, VoteIdeaVariables> ref() {
    VoteIdeaVariables vars= VoteIdeaVariables(ideaId: ideaId,userId: userId,type: type,);
    return _dataConnect.mutation("voteIdea", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class VoteIdeaVoteUpsert {
  final String ideaId;
  final String userId;
  VoteIdeaVoteUpsert.fromJson(dynamic json):
  
  ideaId = nativeFromJson<String>(json['ideaId']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VoteIdeaVoteUpsert otherTyped = other as VoteIdeaVoteUpsert;
    return ideaId == otherTyped.ideaId && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([ideaId.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ideaId'] = nativeToJson<String>(ideaId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  VoteIdeaVoteUpsert({
    required this.ideaId,
    required this.userId,
  });
}

@immutable
class VoteIdeaData {
  final VoteIdeaVoteUpsert vote_upsert;
  VoteIdeaData.fromJson(dynamic json):
  
  vote_upsert = VoteIdeaVoteUpsert.fromJson(json['vote_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VoteIdeaData otherTyped = other as VoteIdeaData;
    return vote_upsert == otherTyped.vote_upsert;
    
  }
  @override
  int get hashCode => vote_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vote_upsert'] = vote_upsert.toJson();
    return json;
  }

  VoteIdeaData({
    required this.vote_upsert,
  });
}

@immutable
class VoteIdeaVariables {
  final String ideaId;
  final String userId;
  final String type;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  VoteIdeaVariables.fromJson(Map<String, dynamic> json):
  
  ideaId = nativeFromJson<String>(json['ideaId']),
  userId = nativeFromJson<String>(json['userId']),
  type = nativeFromJson<String>(json['type']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VoteIdeaVariables otherTyped = other as VoteIdeaVariables;
    return ideaId == otherTyped.ideaId && 
    userId == otherTyped.userId && 
    type == otherTyped.type;
    
  }
  @override
  int get hashCode => Object.hashAll([ideaId.hashCode, userId.hashCode, type.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ideaId'] = nativeToJson<String>(ideaId);
    json['userId'] = nativeToJson<String>(userId);
    json['type'] = nativeToJson<String>(type);
    return json;
  }

  VoteIdeaVariables({
    required this.ideaId,
    required this.userId,
    required this.type,
  });
}

