part of 'hitian_connector.dart';

class GetUserVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetUserVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetUserData> dataDeserializer = (dynamic json)  => GetUserData.fromJson(jsonDecode(json));
  Serializer<GetUserVariables> varsSerializer = (GetUserVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserData, GetUserVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserData, GetUserVariables> ref() {
    GetUserVariables vars= GetUserVariables(id: id,);
    return _dataConnect.query("getUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUserUser {
  final String id;
  final String name;
  final String email;
  final String? rollNumber;
  final String? domain;
  final int? batch;
  final String? profilePic;
  final String? role;
  final Timestamp createdAt;
  GetUserUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  email = nativeFromJson<String>(json['email']),
  rollNumber = json['rollNumber'] == null ? null : nativeFromJson<String>(json['rollNumber']),
  domain = json['domain'] == null ? null : nativeFromJson<String>(json['domain']),
  batch = json['batch'] == null ? null : nativeFromJson<int>(json['batch']),
  profilePic = json['profilePic'] == null ? null : nativeFromJson<String>(json['profilePic']),
  role = json['role'] == null ? null : nativeFromJson<String>(json['role']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserUser otherTyped = other as GetUserUser;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    email == otherTyped.email && 
    rollNumber == otherTyped.rollNumber && 
    domain == otherTyped.domain && 
    batch == otherTyped.batch && 
    profilePic == otherTyped.profilePic && 
    role == otherTyped.role && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, email.hashCode, rollNumber.hashCode, domain.hashCode, batch.hashCode, profilePic.hashCode, role.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['email'] = nativeToJson<String>(email);
    if (rollNumber != null) {
      json['rollNumber'] = nativeToJson<String?>(rollNumber);
    }
    if (domain != null) {
      json['domain'] = nativeToJson<String?>(domain);
    }
    if (batch != null) {
      json['batch'] = nativeToJson<int?>(batch);
    }
    if (profilePic != null) {
      json['profilePic'] = nativeToJson<String?>(profilePic);
    }
    if (role != null) {
      json['role'] = nativeToJson<String?>(role);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  const GetUserUser({
    required this.id,
    required this.name,
    required this.email,
    this.rollNumber,
    this.domain,
    this.batch,
    this.profilePic,
    this.role,
    required this.createdAt,
  });
}

@immutable
class GetUserData {
  final GetUserUser? user;
  GetUserData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetUserUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserData otherTyped = other as GetUserData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  const GetUserData({
    this.user,
  });
}

@immutable
class GetUserVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUserVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserVariables otherTyped = other as GetUserVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetUserVariables({
    required this.id,
  });
}

