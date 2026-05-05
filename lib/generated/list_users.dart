part of 'hitian_connector.dart';

class ListUsersVariablesBuilder {
  final Optional<String> _domain = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListUsersVariablesBuilder domain(String? t) {
   _domain.value = t;
   return this;
  }

  ListUsersVariablesBuilder(this._dataConnect, );
  Deserializer<ListUsersData> dataDeserializer = (dynamic json)  => ListUsersData.fromJson(jsonDecode(json));
  Serializer<ListUsersVariables> varsSerializer = (ListUsersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListUsersData, ListUsersVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListUsersData, ListUsersVariables> ref() {
    ListUsersVariables vars= ListUsersVariables(domain: _domain,);
    return _dataConnect.query("listUsers", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListUsersUsers {
  final String id;
  final String name;
  final String? domain;
  final String? profilePic;
  ListUsersUsers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  domain = json['domain'] == null ? null : nativeFromJson<String>(json['domain']),
  profilePic = json['profilePic'] == null ? null : nativeFromJson<String>(json['profilePic']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUsersUsers otherTyped = other as ListUsersUsers;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    domain == otherTyped.domain && 
    profilePic == otherTyped.profilePic;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, domain.hashCode, profilePic.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (domain != null) {
      json['domain'] = nativeToJson<String?>(domain);
    }
    if (profilePic != null) {
      json['profilePic'] = nativeToJson<String?>(profilePic);
    }
    return json;
  }

  const ListUsersUsers({
    required this.id,
    required this.name,
    this.domain,
    this.profilePic,
  });
}

@immutable
class ListUsersData {
  final List<ListUsersUsers> users;
  ListUsersData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => ListUsersUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUsersData otherTyped = other as ListUsersData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  const ListUsersData({
    required this.users,
  });
}

class ListUsersVariables {
  late final Optional<String>domain;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListUsersVariables.fromJson(Map<String, dynamic> json) {
  
  
    domain = Optional.optional(nativeFromJson, nativeToJson);
    domain.value = json['domain'] == null ? null : nativeFromJson<String>(json['domain']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUsersVariables otherTyped = other as ListUsersVariables;
    return domain == otherTyped.domain;
    
  }
  @override
  int get hashCode => domain.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(domain.state == OptionalState.set) {
      json['domain'] = domain.toJson();
    }
    return json;
  }

  ListUsersVariables({
    required this.domain,
  });
}

