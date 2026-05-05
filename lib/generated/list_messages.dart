part of 'hitian_connector.dart';

class ListMessagesVariablesBuilder {
  String groupId;
  final Optional<Timestamp> _after = Optional.optional((json) => json['after'] = Timestamp.fromJson(json['after']), defaultSerializer);

  final FirebaseDataConnect _dataConnect;  ListMessagesVariablesBuilder after(Timestamp? t) {
   _after.value = t;
   return this;
  }

  ListMessagesVariablesBuilder(this._dataConnect, {required  this.groupId,});
  Deserializer<ListMessagesData> dataDeserializer = (dynamic json)  => ListMessagesData.fromJson(jsonDecode(json));
  Serializer<ListMessagesVariables> varsSerializer = (ListMessagesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListMessagesData, ListMessagesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListMessagesData, ListMessagesVariables> ref() {
    ListMessagesVariables vars= ListMessagesVariables(groupId: groupId,after: _after,);
    return _dataConnect.query("listMessages", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListMessagesMessages {
  final String id;
  final String text;
  final String type;
  final String? metadata;
  final Timestamp timestamp;
  final ListMessagesMessagesSender sender;
  final List<ListMessagesMessagesReactions> reactions;
  ListMessagesMessages.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  text = nativeFromJson<String>(json['text']),
  type = nativeFromJson<String>(json['type']),
  metadata = json['metadata'] == null ? null : nativeFromJson<String>(json['metadata']),
  timestamp = Timestamp.fromJson(json['timestamp']),
  sender = ListMessagesMessagesSender.fromJson(json['sender']),
  reactions = (json['reactions'] as List<dynamic>)
        .map((e) => ListMessagesMessagesReactions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesMessages otherTyped = other as ListMessagesMessages;
    return id == otherTyped.id && 
    text == otherTyped.text && 
    type == otherTyped.type && 
    metadata == otherTyped.metadata && 
    timestamp == otherTyped.timestamp && 
    sender == otherTyped.sender && 
    reactions == otherTyped.reactions;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, text.hashCode, type.hashCode, metadata.hashCode, timestamp.hashCode, sender.hashCode, reactions.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['text'] = nativeToJson<String>(text);
    json['type'] = nativeToJson<String>(type);
    if (metadata != null) {
      json['metadata'] = nativeToJson<String?>(metadata);
    }
    json['timestamp'] = timestamp.toJson();
    json['sender'] = sender.toJson();
    json['reactions'] = reactions.map((e) => e.toJson()).toList();
    return json;
  }

  const ListMessagesMessages({
    required this.id,
    required this.text,
    required this.type,
    this.metadata,
    required this.timestamp,
    required this.sender,
    required this.reactions,
  });
}

@immutable
class ListMessagesMessagesSender {
  final String id;
  final String name;
  final String? profilePic;
  ListMessagesMessagesSender.fromJson(dynamic json):
  
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

    final ListMessagesMessagesSender otherTyped = other as ListMessagesMessagesSender;
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

  const ListMessagesMessagesSender({
    required this.id,
    required this.name,
    this.profilePic,
  });
}

@immutable
class ListMessagesMessagesReactions {
  final ListMessagesMessagesReactionsUser user;
  final String emoji;
  ListMessagesMessagesReactions.fromJson(dynamic json):
  
  user = ListMessagesMessagesReactionsUser.fromJson(json['user']),
  emoji = nativeFromJson<String>(json['emoji']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesMessagesReactions otherTyped = other as ListMessagesMessagesReactions;
    return user == otherTyped.user && 
    emoji == otherTyped.emoji;
    
  }
  @override
  int get hashCode => Object.hashAll([user.hashCode, emoji.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    json['emoji'] = nativeToJson<String>(emoji);
    return json;
  }

  const ListMessagesMessagesReactions({
    required this.user,
    required this.emoji,
  });
}

@immutable
class ListMessagesMessagesReactionsUser {
  final String id;
  final String name;
  ListMessagesMessagesReactionsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesMessagesReactionsUser otherTyped = other as ListMessagesMessagesReactionsUser;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  const ListMessagesMessagesReactionsUser({
    required this.id,
    required this.name,
  });
}

@immutable
class ListMessagesData {
  final List<ListMessagesMessages> messages;
  ListMessagesData.fromJson(dynamic json):
  
  messages = (json['messages'] as List<dynamic>)
        .map((e) => ListMessagesMessages.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesData otherTyped = other as ListMessagesData;
    return messages == otherTyped.messages;
    
  }
  @override
  int get hashCode => messages.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messages'] = messages.map((e) => e.toJson()).toList();
    return json;
  }

  const ListMessagesData({
    required this.messages,
  });
}

class ListMessagesVariables {
  final String groupId;
  late final Optional<Timestamp>after;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListMessagesVariables.fromJson(Map<String, dynamic> json):
  
  groupId = nativeFromJson<String>(json['groupId']) {
  
  
  
    after = Optional.optional((json) => json['after'] = Timestamp.fromJson(json['after']), defaultSerializer);
    after.value = json['after'] == null ? null : Timestamp.fromJson(json['after']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesVariables otherTyped = other as ListMessagesVariables;
    return groupId == otherTyped.groupId && 
    after == otherTyped.after;
    
  }
  @override
  int get hashCode => Object.hashAll([groupId.hashCode, after.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['groupId'] = nativeToJson<String>(groupId);
    if(after.state == OptionalState.set) {
      json['after'] = after.toJson();
    }
    return json;
  }

  ListMessagesVariables({
    required this.groupId,
    required this.after,
  });
}

