part of 'hitian_connector.dart';

class ListCriticismsVariablesBuilder {
  String ideaId;

  final FirebaseDataConnect _dataConnect;
  ListCriticismsVariablesBuilder(this._dataConnect, {required  this.ideaId,});
  Deserializer<ListCriticismsData> dataDeserializer = (dynamic json)  => ListCriticismsData.fromJson(jsonDecode(json));
  Serializer<ListCriticismsVariables> varsSerializer = (ListCriticismsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListCriticismsData, ListCriticismsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListCriticismsData, ListCriticismsVariables> ref() {
    ListCriticismsVariables vars= ListCriticismsVariables(ideaId: ideaId,);
    return _dataConnect.query("listCriticisms", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListCriticismsCriticisms {
  final String id;
  final String content;
  final Timestamp timestamp;
  final ListCriticismsCriticismsUser user;
  ListCriticismsCriticisms.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  content = nativeFromJson<String>(json['content']),
  timestamp = Timestamp.fromJson(json['timestamp']),
  user = ListCriticismsCriticismsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCriticismsCriticisms otherTyped = other as ListCriticismsCriticisms;
    return id == otherTyped.id && 
    content == otherTyped.content && 
    timestamp == otherTyped.timestamp && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, content.hashCode, timestamp.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['content'] = nativeToJson<String>(content);
    json['timestamp'] = timestamp.toJson();
    json['user'] = user.toJson();
    return json;
  }

  const ListCriticismsCriticisms({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.user,
  });
}

@immutable
class ListCriticismsCriticismsUser {
  final String id;
  final String name;
  final String? profilePic;
  ListCriticismsCriticismsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  profilePic = json['profilePic'] == null ? null : nativeFromJson<String>(json['profilePic']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCriticismsCriticismsUser otherTyped = other as ListCriticismsCriticismsUser;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    profilePic == otherTyped.profilePic;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, profilePic.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (profilePic != null) {
      json['profilePic'] = nativeToJson<String?>(profilePic);
    }
    return json;
  }

  const ListCriticismsCriticismsUser({
    required this.id,
    required this.name,
    this.profilePic,
  });
}

@immutable
class ListCriticismsData {
  final List<ListCriticismsCriticisms> criticisms;
  ListCriticismsData.fromJson(dynamic json):
  
  criticisms = (json['criticisms'] as List<dynamic>)
        .map((e) => ListCriticismsCriticisms.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCriticismsData otherTyped = other as ListCriticismsData;
    return criticisms == otherTyped.criticisms;
    
  }
  @override
  int get hashCode => criticisms.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['criticisms'] = criticisms.map((e) => e.toJson()).toList();
    return json;
  }

  const ListCriticismsData({
    required this.criticisms,
  });
}

@immutable
class ListCriticismsVariables {
  final String ideaId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListCriticismsVariables.fromJson(Map<String, dynamic> json):
  
  ideaId = nativeFromJson<String>(json['ideaId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCriticismsVariables otherTyped = other as ListCriticismsVariables;
    return ideaId == otherTyped.ideaId;
    
  }
  @override
  int get hashCode => ideaId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ideaId'] = nativeToJson<String>(ideaId);
    return json;
  }

  const ListCriticismsVariables({
    required this.ideaId,
  });
}

