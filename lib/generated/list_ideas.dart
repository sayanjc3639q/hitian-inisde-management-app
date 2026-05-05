part of 'hitian_connector.dart';

class ListIdeasVariablesBuilder {
  final Optional<String> _category = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _authorId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListIdeasVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }
  ListIdeasVariablesBuilder authorId(String? t) {
   _authorId.value = t;
   return this;
  }

  ListIdeasVariablesBuilder(this._dataConnect, );
  Deserializer<ListIdeasData> dataDeserializer = (dynamic json)  => ListIdeasData.fromJson(jsonDecode(json));
  Serializer<ListIdeasVariables> varsSerializer = (ListIdeasVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListIdeasData, ListIdeasVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListIdeasData, ListIdeasVariables> ref() {
    ListIdeasVariables vars= ListIdeasVariables(category: _category,authorId: _authorId,);
    return _dataConnect.query("listIdeas", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListIdeasIdeas {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final Timestamp timestamp;
  final ListIdeasIdeasAuthor author;
  final List<ListIdeasIdeasVotesOnIdea> votesOnIdea;
  final List<ListIdeasIdeasCriticismsOnIdea> criticismsOnIdea;
  ListIdeasIdeas.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  description = nativeFromJson<String>(json['description']),
  category = nativeFromJson<String>(json['category']),
  status = nativeFromJson<String>(json['status']),
  timestamp = Timestamp.fromJson(json['timestamp']),
  author = ListIdeasIdeasAuthor.fromJson(json['author']),
  votesOnIdea = (json['votes_on_idea'] as List<dynamic>)
        .map((e) => ListIdeasIdeasVotesOnIdea.fromJson(e))
        .toList(),
  criticismsOnIdea = (json['criticisms_on_idea'] as List<dynamic>)
        .map((e) => ListIdeasIdeasCriticismsOnIdea.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListIdeasIdeas otherTyped = other as ListIdeasIdeas;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    description == otherTyped.description && 
    category == otherTyped.category && 
    status == otherTyped.status && 
    timestamp == otherTyped.timestamp && 
    author == otherTyped.author && 
    votesOnIdea == otherTyped.votesOnIdea && 
    criticismsOnIdea == otherTyped.criticismsOnIdea;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, description.hashCode, category.hashCode, status.hashCode, timestamp.hashCode, author.hashCode, votesOnIdea.hashCode, criticismsOnIdea.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['description'] = nativeToJson<String>(description);
    json['category'] = nativeToJson<String>(category);
    json['status'] = nativeToJson<String>(status);
    json['timestamp'] = timestamp.toJson();
    json['author'] = author.toJson();
    json['votes_on_idea'] = votesOnIdea.map((e) => e.toJson()).toList();
    json['criticisms_on_idea'] = criticismsOnIdea.map((e) => e.toJson()).toList();
    return json;
  }

  const ListIdeasIdeas({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.timestamp,
    required this.author,
    required this.votesOnIdea,
    required this.criticismsOnIdea,
  });
}

@immutable
class ListIdeasIdeasAuthor {
  final String id;
  final String name;
  final String? profilePic;
  ListIdeasIdeasAuthor.fromJson(dynamic json):
  
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

    final ListIdeasIdeasAuthor otherTyped = other as ListIdeasIdeasAuthor;
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

  const ListIdeasIdeasAuthor({
    required this.id,
    required this.name,
    this.profilePic,
  });
}

@immutable
class ListIdeasIdeasVotesOnIdea {
  final String type;
  final String userId;
  ListIdeasIdeasVotesOnIdea.fromJson(dynamic json):
  
  type = nativeFromJson<String>(json['type']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListIdeasIdeasVotesOnIdea otherTyped = other as ListIdeasIdeasVotesOnIdea;
    return type == otherTyped.type && 
    userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => Object.hashAll([type.hashCode, userId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['type'] = nativeToJson<String>(type);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const ListIdeasIdeasVotesOnIdea({
    required this.type,
    required this.userId,
  });
}

@immutable
class ListIdeasIdeasCriticismsOnIdea {
  final String id;
  final String content;
  final Timestamp timestamp;
  final ListIdeasIdeasCriticismsOnIdeaUser user;
  ListIdeasIdeasCriticismsOnIdea.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  content = nativeFromJson<String>(json['content']),
  timestamp = Timestamp.fromJson(json['timestamp']),
  user = ListIdeasIdeasCriticismsOnIdeaUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListIdeasIdeasCriticismsOnIdea otherTyped = other as ListIdeasIdeasCriticismsOnIdea;
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

  const ListIdeasIdeasCriticismsOnIdea({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.user,
  });
}

@immutable
class ListIdeasIdeasCriticismsOnIdeaUser {
  final String name;
  final String? profilePic;
  ListIdeasIdeasCriticismsOnIdeaUser.fromJson(dynamic json):
  
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

    final ListIdeasIdeasCriticismsOnIdeaUser otherTyped = other as ListIdeasIdeasCriticismsOnIdeaUser;
    return name == otherTyped.name && 
    profilePic == otherTyped.profilePic;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, profilePic.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    if (profilePic != null) {
      json['profilePic'] = nativeToJson<String?>(profilePic);
    }
    return json;
  }

  const ListIdeasIdeasCriticismsOnIdeaUser({
    required this.name,
    this.profilePic,
  });
}

@immutable
class ListIdeasData {
  final List<ListIdeasIdeas> ideas;
  ListIdeasData.fromJson(dynamic json):
  
  ideas = (json['ideas'] as List<dynamic>)
        .map((e) => ListIdeasIdeas.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListIdeasData otherTyped = other as ListIdeasData;
    return ideas == otherTyped.ideas;
    
  }
  @override
  int get hashCode => ideas.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ideas'] = ideas.map((e) => e.toJson()).toList();
    return json;
  }

  const ListIdeasData({
    required this.ideas,
  });
}

class ListIdeasVariables {
  late final Optional<String>category;
  late final Optional<String>authorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListIdeasVariables.fromJson(Map<String, dynamic> json) {
  
  
    category = Optional.optional(nativeFromJson, nativeToJson);
    category.value = json['category'] == null ? null : nativeFromJson<String>(json['category']);
  
  
    authorId = Optional.optional(nativeFromJson, nativeToJson);
    authorId.value = json['authorId'] == null ? null : nativeFromJson<String>(json['authorId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListIdeasVariables otherTyped = other as ListIdeasVariables;
    return category == otherTyped.category && 
    authorId == otherTyped.authorId;
    
  }
  @override
  int get hashCode => Object.hashAll([category.hashCode, authorId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(category.state == OptionalState.set) {
      json['category'] = category.toJson();
    }
    if(authorId.state == OptionalState.set) {
      json['authorId'] = authorId.toJson();
    }
    return json;
  }

  ListIdeasVariables({
    required this.category,
    required this.authorId,
  });
}

