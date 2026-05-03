part of 'hitian_connector.dart';

class UpdateProfilePicVariablesBuilder {
  String id;
  Optional<String> _url = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateProfilePicVariablesBuilder url(String? t) {
   _url.value = t;
   return this;
  }

  UpdateProfilePicVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateProfilePicData> dataDeserializer = (dynamic json)  => UpdateProfilePicData.fromJson(jsonDecode(json));
  Serializer<UpdateProfilePicVariables> varsSerializer = (UpdateProfilePicVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateProfilePicData, UpdateProfilePicVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateProfilePicData, UpdateProfilePicVariables> ref() {
    UpdateProfilePicVariables vars= UpdateProfilePicVariables(id: id,url: _url,);
    return _dataConnect.mutation("updateProfilePic", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateProfilePicUserUpdate {
  final String id;
  UpdateProfilePicUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProfilePicUserUpdate otherTyped = other as UpdateProfilePicUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateProfilePicUserUpdate({
    required this.id,
  });
}

@immutable
class UpdateProfilePicData {
  final UpdateProfilePicUserUpdate? user_update;
  UpdateProfilePicData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : UpdateProfilePicUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProfilePicData otherTyped = other as UpdateProfilePicData;
    return user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => user_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  UpdateProfilePicData({
    this.user_update,
  });
}

@immutable
class UpdateProfilePicVariables {
  final String id;
  late final Optional<String>url;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateProfilePicVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    url = Optional.optional(nativeFromJson, nativeToJson);
    url.value = json['url'] == null ? null : nativeFromJson<String>(json['url']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProfilePicVariables otherTyped = other as UpdateProfilePicVariables;
    return id == otherTyped.id && 
    url == otherTyped.url;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, url.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(url.state == OptionalState.set) {
      json['url'] = url.toJson();
    }
    return json;
  }

  UpdateProfilePicVariables({
    required this.id,
    required this.url,
  });
}

