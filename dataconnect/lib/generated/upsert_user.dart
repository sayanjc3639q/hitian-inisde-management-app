part of 'hitian_connector.dart';

class UpsertUserVariablesBuilder {
  String id;
  String name;
  String email;
  final Optional<String> _rollNumber = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _domain = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<int> _batch = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertUserVariablesBuilder rollNumber(String? t) {
   _rollNumber.value = t;
   return this;
  }
  UpsertUserVariablesBuilder domain(String? t) {
   _domain.value = t;
   return this;
  }
  UpsertUserVariablesBuilder batch(int? t) {
   _batch.value = t;
   return this;
  }

  UpsertUserVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.email,});
  Deserializer<UpsertUserData> dataDeserializer = (dynamic json)  => UpsertUserData.fromJson(jsonDecode(json));
  Serializer<UpsertUserVariables> varsSerializer = (UpsertUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertUserData, UpsertUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertUserData, UpsertUserVariables> ref() {
    UpsertUserVariables vars= UpsertUserVariables(id: id,name: name,email: email,rollNumber: _rollNumber,domain: _domain,batch: _batch,);
    return _dataConnect.mutation("upsertUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertUserUserUpsert {
  final String id;
  UpsertUserUserUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserUserUpsert otherTyped = other as UpsertUserUserUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpsertUserUserUpsert({
    required this.id,
  });
}

class UpsertUserData {
  final UpsertUserUserUpsert userUpsert;
  UpsertUserData.fromJson(dynamic json):
  
  userUpsert = UpsertUserUserUpsert.fromJson(json['user_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserData otherTyped = other as UpsertUserData;
    return userUpsert == otherTyped.userUpsert;
    
  }
  @override
  int get hashCode => userUpsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_upsert'] = userUpsert.toJson();
    return json;
  }

  UpsertUserData({
    required this.userUpsert,
  });
}

class UpsertUserVariables {
  final String id;
  final String name;
  final String email;
  late final Optional<String>rollNumber;
  late final Optional<String>domain;
  late final Optional<int>batch;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertUserVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  email = nativeFromJson<String>(json['email']) {
  
  
  
  
  
    rollNumber = Optional.optional(nativeFromJson, nativeToJson);
    rollNumber.value = json['rollNumber'] == null ? null : nativeFromJson<String>(json['rollNumber']);
  
  
    domain = Optional.optional(nativeFromJson, nativeToJson);
    domain.value = json['domain'] == null ? null : nativeFromJson<String>(json['domain']);
  
  
    batch = Optional.optional(nativeFromJson, nativeToJson);
    batch.value = json['batch'] == null ? null : nativeFromJson<int>(json['batch']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserVariables otherTyped = other as UpsertUserVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    email == otherTyped.email && 
    rollNumber == otherTyped.rollNumber && 
    domain == otherTyped.domain && 
    batch == otherTyped.batch;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, email.hashCode, rollNumber.hashCode, domain.hashCode, batch.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['email'] = nativeToJson<String>(email);
    if(rollNumber.state == OptionalState.set) {
      json['rollNumber'] = rollNumber.toJson();
    }
    if(domain.state == OptionalState.set) {
      json['domain'] = domain.toJson();
    }
    if(batch.state == OptionalState.set) {
      json['batch'] = batch.toJson();
    }
    return json;
  }

  UpsertUserVariables({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.domain,
    required this.batch,
  });
}

