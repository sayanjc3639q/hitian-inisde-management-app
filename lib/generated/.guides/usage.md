# Basic Usage

```dart
HitianConnectorConnector.instance.upsertUser(upsertUserVariables).execute();
HitianConnectorConnector.instance.updateProfilePic(updateProfilePicVariables).execute();
HitianConnectorConnector.instance.getUser(getUserVariables).execute();
HitianConnectorConnector.instance.createIdea(createIdeaVariables).execute();
HitianConnectorConnector.instance.voteIdea(voteIdeaVariables).execute();
HitianConnectorConnector.instance.addCriticism(addCriticismVariables).execute();
HitianConnectorConnector.instance.listIdeas(listIdeasVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await HitianConnectorConnector.instance.listIdeas({ ... })
.category(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

