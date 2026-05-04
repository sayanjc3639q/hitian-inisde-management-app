# hitian_data SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
HitianConnectorConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### getUser
#### Required Arguments
```dart
String id = ...;
HitianConnectorConnector.instance.getUser(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<getUserData, getUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.getUser(
  id: id,
);
getUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = HitianConnectorConnector.instance.getUser(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### listUsers
#### Required Arguments
```dart
// No required arguments
HitianConnectorConnector.instance.listUsers().execute();
```

#### Optional Arguments
We return a builder for each query. For listUsers, we created `listUsersBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListUsersVariablesBuilder {
  ...
 
  ListUsersVariablesBuilder domain(String? t) {
   _domain.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.listUsers()
.domain(domain)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<listUsersData, listUsersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listUsers();
listUsersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = HitianConnectorConnector.instance.listUsers().ref();
ref.execute();

ref.subscribe(...);
```


### listAllUsers
#### Required Arguments
```dart
// No required arguments
HitianConnectorConnector.instance.listAllUsers().execute();
```



#### Return Type
`execute()` returns a `QueryResult<listAllUsersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listAllUsers();
listAllUsersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = HitianConnectorConnector.instance.listAllUsers().ref();
ref.execute();

ref.subscribe(...);
```


### listIdeas
#### Required Arguments
```dart
// No required arguments
HitianConnectorConnector.instance.listIdeas().execute();
```

#### Optional Arguments
We return a builder for each query. For listIdeas, we created `listIdeasBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListIdeasVariablesBuilder {
  ...
 
  ListIdeasVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }
  ListIdeasVariablesBuilder authorId(String? t) {
   _authorId.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.listIdeas()
.category(category)
.authorId(authorId)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<listIdeasData, listIdeasVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listIdeas();
listIdeasData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = HitianConnectorConnector.instance.listIdeas().ref();
ref.execute();

ref.subscribe(...);
```


### listCriticisms
#### Required Arguments
```dart
String ideaId = ...;
HitianConnectorConnector.instance.listCriticisms(
  ideaId: ideaId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<listCriticismsData, listCriticismsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listCriticisms(
  ideaId: ideaId,
);
listCriticismsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String ideaId = ...;

final ref = HitianConnectorConnector.instance.listCriticisms(
  ideaId: ideaId,
).ref();
ref.execute();

ref.subscribe(...);
```


### listTasks
#### Required Arguments
```dart
// No required arguments
HitianConnectorConnector.instance.listTasks().execute();
```

#### Optional Arguments
We return a builder for each query. For listTasks, we created `listTasksBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListTasksVariablesBuilder {
  ...
 
  ListTasksVariablesBuilder assigneeId(String? t) {
   _assigneeId.value = t;
   return this;
  }
  ListTasksVariablesBuilder status(String? t) {
   _status.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.listTasks()
.assigneeId(assigneeId)
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<listTasksData, listTasksVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listTasks();
listTasksData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = HitianConnectorConnector.instance.listTasks().ref();
ref.execute();

ref.subscribe(...);
```


### listEvents
#### Required Arguments
```dart
// No required arguments
HitianConnectorConnector.instance.listEvents().execute();
```

#### Optional Arguments
We return a builder for each query. For listEvents, we created `listEventsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListEventsVariablesBuilder {
  ...
 
  ListEventsVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.listEvents()
.category(category)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<listEventsData, listEventsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listEvents();
listEventsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = HitianConnectorConnector.instance.listEvents().ref();
ref.execute();

ref.subscribe(...);
```


### listEventsByAttendee
#### Required Arguments
```dart
String userId = ...;
HitianConnectorConnector.instance.listEventsByAttendee(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<listEventsByAttendeeData, listEventsByAttendeeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listEventsByAttendee(
  userId: userId,
);
listEventsByAttendeeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = HitianConnectorConnector.instance.listEventsByAttendee(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### listEventsByGroup
#### Required Arguments
```dart
// No required arguments
HitianConnectorConnector.instance.listEventsByGroup().execute();
```

#### Optional Arguments
We return a builder for each query. For listEventsByGroup, we created `listEventsByGroupBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListEventsByGroupVariablesBuilder {
  ...
 
  ListEventsByGroupVariablesBuilder groupIds(List<String>? t) {
   _groupIds.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.listEventsByGroup()
.groupIds(groupIds)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<listEventsByGroupData, listEventsByGroupVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listEventsByGroup();
listEventsByGroupData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = HitianConnectorConnector.instance.listEventsByGroup().ref();
ref.execute();

ref.subscribe(...);
```


### listMessages
#### Required Arguments
```dart
String groupId = ...;
HitianConnectorConnector.instance.listMessages(
  groupId: groupId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For listMessages, we created `listMessagesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListMessagesVariablesBuilder {
  ...
   ListMessagesVariablesBuilder after(Timestamp? t) {
   _after.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.listMessages(
  groupId: groupId,
)
.after(after)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<listMessagesData, listMessagesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.listMessages(
  groupId: groupId,
);
listMessagesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;

final ref = HitianConnectorConnector.instance.listMessages(
  groupId: groupId,
).ref();
ref.execute();

ref.subscribe(...);
```


### getLastRead
#### Required Arguments
```dart
String groupId = ...;
String userId = ...;
HitianConnectorConnector.instance.getLastRead(
  groupId: groupId,
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<getLastReadData, getLastReadVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.getLastRead(
  groupId: groupId,
  userId: userId,
);
getLastReadData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;
String userId = ...;

final ref = HitianConnectorConnector.instance.getLastRead(
  groupId: groupId,
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### getUnreadMessages
#### Required Arguments
```dart
String groupId = ...;
Timestamp lastRead = ...;
HitianConnectorConnector.instance.getUnreadMessages(
  groupId: groupId,
  lastRead: lastRead,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<getUnreadMessagesData, getUnreadMessagesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await HitianConnectorConnector.instance.getUnreadMessages(
  groupId: groupId,
  lastRead: lastRead,
);
getUnreadMessagesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;
Timestamp lastRead = ...;

final ref = HitianConnectorConnector.instance.getUnreadMessages(
  groupId: groupId,
  lastRead: lastRead,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### upsertUser
#### Required Arguments
```dart
String id = ...;
String name = ...;
String email = ...;
HitianConnectorConnector.instance.upsertUser(
  id: id,
  name: name,
  email: email,
).execute();
```

#### Optional Arguments
We return a builder for each query. For upsertUser, we created `upsertUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertUserVariablesBuilder {
  ...
   UpsertUserVariablesBuilder rollNumber(String? t) {
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

  ...
}
HitianConnectorConnector.instance.upsertUser(
  id: id,
  name: name,
  email: email,
)
.rollNumber(rollNumber)
.domain(domain)
.batch(batch)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<upsertUserData, upsertUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.upsertUser(
  id: id,
  name: name,
  email: email,
);
upsertUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String email = ...;

final ref = HitianConnectorConnector.instance.upsertUser(
  id: id,
  name: name,
  email: email,
).ref();
ref.execute();
```


### updateProfilePic
#### Required Arguments
```dart
String id = ...;
HitianConnectorConnector.instance.updateProfilePic(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For updateProfilePic, we created `updateProfilePicBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateProfilePicVariablesBuilder {
  ...
   UpdateProfilePicVariablesBuilder url(String? t) {
   _url.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.updateProfilePic(
  id: id,
)
.url(url)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<updateProfilePicData, updateProfilePicVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.updateProfilePic(
  id: id,
);
updateProfilePicData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = HitianConnectorConnector.instance.updateProfilePic(
  id: id,
).ref();
ref.execute();
```


### createIdea
#### Required Arguments
```dart
String title = ...;
String description = ...;
String category = ...;
String authorId = ...;
HitianConnectorConnector.instance.createIdea(
  title: title,
  description: description,
  category: category,
  authorId: authorId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<createIdeaData, createIdeaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.createIdea(
  title: title,
  description: description,
  category: category,
  authorId: authorId,
);
createIdeaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String description = ...;
String category = ...;
String authorId = ...;

final ref = HitianConnectorConnector.instance.createIdea(
  title: title,
  description: description,
  category: category,
  authorId: authorId,
).ref();
ref.execute();
```


### voteIdea
#### Required Arguments
```dart
String ideaId = ...;
String userId = ...;
String type = ...;
HitianConnectorConnector.instance.voteIdea(
  ideaId: ideaId,
  userId: userId,
  type: type,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<voteIdeaData, voteIdeaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.voteIdea(
  ideaId: ideaId,
  userId: userId,
  type: type,
);
voteIdeaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String ideaId = ...;
String userId = ...;
String type = ...;

final ref = HitianConnectorConnector.instance.voteIdea(
  ideaId: ideaId,
  userId: userId,
  type: type,
).ref();
ref.execute();
```


### addCriticism
#### Required Arguments
```dart
String ideaId = ...;
String userId = ...;
String content = ...;
HitianConnectorConnector.instance.addCriticism(
  ideaId: ideaId,
  userId: userId,
  content: content,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<addCriticismData, addCriticismVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.addCriticism(
  ideaId: ideaId,
  userId: userId,
  content: content,
);
addCriticismData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String ideaId = ...;
String userId = ...;
String content = ...;

final ref = HitianConnectorConnector.instance.addCriticism(
  ideaId: ideaId,
  userId: userId,
  content: content,
).ref();
ref.execute();
```


### deleteIdea
#### Required Arguments
```dart
String id = ...;
HitianConnectorConnector.instance.deleteIdea(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<deleteIdeaData, deleteIdeaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.deleteIdea(
  id: id,
);
deleteIdeaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = HitianConnectorConnector.instance.deleteIdea(
  id: id,
).ref();
ref.execute();
```


### updateIdeaStatus
#### Required Arguments
```dart
String id = ...;
String status = ...;
HitianConnectorConnector.instance.updateIdeaStatus(
  id: id,
  status: status,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<updateIdeaStatusData, updateIdeaStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.updateIdeaStatus(
  id: id,
  status: status,
);
updateIdeaStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String status = ...;

final ref = HitianConnectorConnector.instance.updateIdeaStatus(
  id: id,
  status: status,
).ref();
ref.execute();
```


### createTask
#### Required Arguments
```dart
String text = ...;
String assigneeId = ...;
String senderId = ...;
Timestamp deadline = ...;
String groupId = ...;
HitianConnectorConnector.instance.createTask(
  text: text,
  assigneeId: assigneeId,
  senderId: senderId,
  deadline: deadline,
  groupId: groupId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<createTaskData, createTaskVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.createTask(
  text: text,
  assigneeId: assigneeId,
  senderId: senderId,
  deadline: deadline,
  groupId: groupId,
);
createTaskData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String text = ...;
String assigneeId = ...;
String senderId = ...;
Timestamp deadline = ...;
String groupId = ...;

final ref = HitianConnectorConnector.instance.createTask(
  text: text,
  assigneeId: assigneeId,
  senderId: senderId,
  deadline: deadline,
  groupId: groupId,
).ref();
ref.execute();
```


### updateTaskStatus
#### Required Arguments
```dart
String id = ...;
String status = ...;
HitianConnectorConnector.instance.updateTaskStatus(
  id: id,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For updateTaskStatus, we created `updateTaskStatusBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateTaskStatusVariablesBuilder {
  ...
   UpdateTaskStatusVariablesBuilder timestamp(Timestamp? t) {
   _timestamp.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.updateTaskStatus(
  id: id,
  status: status,
)
.timestamp(timestamp)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<updateTaskStatusData, updateTaskStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.updateTaskStatus(
  id: id,
  status: status,
);
updateTaskStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String status = ...;

final ref = HitianConnectorConnector.instance.updateTaskStatus(
  id: id,
  status: status,
).ref();
ref.execute();
```


### createEvent
#### Required Arguments
```dart
String title = ...;
String category = ...;
Timestamp dateTime = ...;
String senderId = ...;
String groupId = ...;
HitianConnectorConnector.instance.createEvent(
  title: title,
  category: category,
  dateTime: dateTime,
  senderId: senderId,
  groupId: groupId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For createEvent, we created `createEventBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateEventVariablesBuilder {
  ...
   CreateEventVariablesBuilder location(String? t) {
   _location.value = t;
   return this;
  }
  CreateEventVariablesBuilder link(String? t) {
   _link.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.createEvent(
  title: title,
  category: category,
  dateTime: dateTime,
  senderId: senderId,
  groupId: groupId,
)
.location(location)
.link(link)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<createEventData, createEventVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.createEvent(
  title: title,
  category: category,
  dateTime: dateTime,
  senderId: senderId,
  groupId: groupId,
);
createEventData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String category = ...;
Timestamp dateTime = ...;
String senderId = ...;
String groupId = ...;

final ref = HitianConnectorConnector.instance.createEvent(
  title: title,
  category: category,
  dateTime: dateTime,
  senderId: senderId,
  groupId: groupId,
).ref();
ref.execute();
```


### attendEvent
#### Required Arguments
```dart
String eventId = ...;
String userId = ...;
HitianConnectorConnector.instance.attendEvent(
  eventId: eventId,
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<attendEventData, attendEventVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.attendEvent(
  eventId: eventId,
  userId: userId,
);
attendEventData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String eventId = ...;
String userId = ...;

final ref = HitianConnectorConnector.instance.attendEvent(
  eventId: eventId,
  userId: userId,
).ref();
ref.execute();
```


### unattendEvent
#### Required Arguments
```dart
String eventId = ...;
String userId = ...;
HitianConnectorConnector.instance.unattendEvent(
  eventId: eventId,
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<unattendEventData, unattendEventVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.unattendEvent(
  eventId: eventId,
  userId: userId,
);
unattendEventData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String eventId = ...;
String userId = ...;

final ref = HitianConnectorConnector.instance.unattendEvent(
  eventId: eventId,
  userId: userId,
).ref();
ref.execute();
```


### createMessage
#### Required Arguments
```dart
String groupId = ...;
String senderId = ...;
String text = ...;
HitianConnectorConnector.instance.createMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
).execute();
```

#### Optional Arguments
We return a builder for each query. For createMessage, we created `createMessageBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateMessageVariablesBuilder {
  ...
   CreateMessageVariablesBuilder type(String? t) {
   _type.value = t;
   return this;
  }
  CreateMessageVariablesBuilder metadata(String? t) {
   _metadata.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.createMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
)
.type(type)
.metadata(metadata)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<createMessageData, createMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.createMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
);
createMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;
String senderId = ...;
String text = ...;

final ref = HitianConnectorConnector.instance.createMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
).ref();
ref.execute();
```


### updateMessage
#### Required Arguments
```dart
String id = ...;
String text = ...;
HitianConnectorConnector.instance.updateMessage(
  id: id,
  text: text,
).execute();
```

#### Optional Arguments
We return a builder for each query. For updateMessage, we created `updateMessageBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateMessageVariablesBuilder {
  ...
   UpdateMessageVariablesBuilder metadata(String? t) {
   _metadata.value = t;
   return this;
  }

  ...
}
HitianConnectorConnector.instance.updateMessage(
  id: id,
  text: text,
)
.metadata(metadata)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<updateMessageData, updateMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.updateMessage(
  id: id,
  text: text,
);
updateMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String text = ...;

final ref = HitianConnectorConnector.instance.updateMessage(
  id: id,
  text: text,
).ref();
ref.execute();
```


### deleteMessage
#### Required Arguments
```dart
String id = ...;
HitianConnectorConnector.instance.deleteMessage(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<deleteMessageData, deleteMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.deleteMessage(
  id: id,
);
deleteMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = HitianConnectorConnector.instance.deleteMessage(
  id: id,
).ref();
ref.execute();
```


### upsertLastRead
#### Required Arguments
```dart
String groupId = ...;
String userId = ...;
HitianConnectorConnector.instance.upsertLastRead(
  groupId: groupId,
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<upsertLastReadData, upsertLastReadVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.upsertLastRead(
  groupId: groupId,
  userId: userId,
);
upsertLastReadData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;
String userId = ...;

final ref = HitianConnectorConnector.instance.upsertLastRead(
  groupId: groupId,
  userId: userId,
).ref();
ref.execute();
```


### addReaction
#### Required Arguments
```dart
String messageId = ...;
String userId = ...;
String emoji = ...;
HitianConnectorConnector.instance.addReaction(
  messageId: messageId,
  userId: userId,
  emoji: emoji,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<addReactionData, addReactionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.addReaction(
  messageId: messageId,
  userId: userId,
  emoji: emoji,
);
addReactionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String messageId = ...;
String userId = ...;
String emoji = ...;

final ref = HitianConnectorConnector.instance.addReaction(
  messageId: messageId,
  userId: userId,
  emoji: emoji,
).ref();
ref.execute();
```


### removeReaction
#### Required Arguments
```dart
String messageId = ...;
String userId = ...;
HitianConnectorConnector.instance.removeReaction(
  messageId: messageId,
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<removeReactionData, removeReactionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await HitianConnectorConnector.instance.removeReaction(
  messageId: messageId,
  userId: userId,
);
removeReactionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String messageId = ...;
String userId = ...;

final ref = HitianConnectorConnector.instance.removeReaction(
  messageId: messageId,
  userId: userId,
).ref();
ref.execute();
```

