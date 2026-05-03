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

