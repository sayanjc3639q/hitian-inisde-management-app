part of 'hitian_connector.dart';

class CreateIdeaVariablesBuilder {
  String title;
  String description;
  String category;
  String authorId;

  final FirebaseDataConnect _dataConnect;
  CreateIdeaVariablesBuilder(this._dataConnect, {required  this.title,required  this.description,required  this.category,required  this.authorId,});
  Deserializer<CreateIdeaData> dataDeserializer = (dynamic json)  => CreateIdeaData.fromJson(jsonDecode(json));
  Serializer<CreateIdeaVariables> varsSerializer = (CreateIdeaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateIdeaData, CreateIdeaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateIdeaData, CreateIdeaVariables> ref() {
    CreateIdeaVariables vars= CreateIdeaVariables(title: title,description: description,category: category,authorId: authorId,);
    return _dataConnect.mutation("createIdea", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateIdeaIdeaInsert {
  final String id;
  CreateIdeaIdeaInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateIdeaIdeaInsert otherTyped = other as CreateIdeaIdeaInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateIdeaIdeaInsert({
    required this.id,
  });
}

@immutable
class CreateIdeaData {
  final CreateIdeaIdeaInsert idea_insert;
  CreateIdeaData.fromJson(dynamic json):
  
  idea_insert = CreateIdeaIdeaInsert.fromJson(json['idea_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateIdeaData otherTyped = other as CreateIdeaData;
    return idea_insert == otherTyped.idea_insert;
    
  }
  @override
  int get hashCode => idea_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['idea_insert'] = idea_insert.toJson();
    return json;
  }

  const CreateIdeaData({
    required this.idea_insert,
  });
}

@immutable
class CreateIdeaVariables {
  final String title;
  final String description;
  final String category;
  final String authorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateIdeaVariables.fromJson(Map<String, dynamic> json):
  
  title = nativeFromJson<String>(json['title']),
  description = nativeFromJson<String>(json['description']),
  category = nativeFromJson<String>(json['category']),
  authorId = nativeFromJson<String>(json['authorId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateIdeaVariables otherTyped = other as CreateIdeaVariables;
    return title == otherTyped.title && 
    description == otherTyped.description && 
    category == otherTyped.category && 
    authorId == otherTyped.authorId;
    
  }
  @override
  int get hashCode => Object.hashAll([title.hashCode, description.hashCode, category.hashCode, authorId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['description'] = nativeToJson<String>(description);
    json['category'] = nativeToJson<String>(category);
    json['authorId'] = nativeToJson<String>(authorId);
    return json;
  }

  const CreateIdeaVariables({
    required this.title,
    required this.description,
    required this.category,
    required this.authorId,
  });
}

