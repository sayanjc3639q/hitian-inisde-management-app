part of 'hitian_connector.dart';

class ListAllUsersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListAllUsersVariablesBuilder(this._dataConnect, );
  Deserializer<ListAllUsersData> dataDeserializer = (dynamic json)  => ListAllUsersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListAllUsersData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListAllUsersData, void> ref() {
    
    return _dataConnect.query("listAllUsers", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListAllUsersUsers {
  final String id;
  final String name;
  final String? domain;
  final String? profilePic;
  ListAllUsersUsers.fromJson(dynamic json):
  
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

    final ListAllUsersUsers otherTyped = other as ListAllUsersUsers;
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

  ListAllUsersUsers({
    required this.id,
    required this.name,
    this.domain,
    this.profilePic,
  });
}

@immutable
class ListAllUsersData {
  final List<ListAllUsersUsers> users;
  ListAllUsersData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => ListAllUsersUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAllUsersData otherTyped = other as ListAllUsersData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  ListAllUsersData({
    required this.users,
  });
}

