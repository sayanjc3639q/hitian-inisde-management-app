library hitian_data;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'upsert_user.dart';

part 'update_profile_pic.dart';

part 'get_user.dart';

part 'list_users.dart';

part 'list_all_users.dart';

part 'create_idea.dart';

part 'vote_idea.dart';

part 'add_criticism.dart';

part 'delete_idea.dart';

part 'update_idea_status.dart';

part 'list_ideas.dart';

part 'list_criticisms.dart';

part 'list_tasks.dart';

part 'create_task.dart';

part 'update_task_status.dart';

part 'list_events.dart';

part 'list_events_by_attendee.dart';

part 'create_event.dart';

part 'attend_event.dart';

part 'list_events_by_group.dart';

part 'unattend_event.dart';

part 'list_messages.dart';

part 'create_message.dart';

part 'update_message.dart';

part 'delete_message.dart';

part 'upsert_last_read.dart';

part 'get_last_read.dart';

part 'add_reaction.dart';

part 'remove_reaction.dart';

part 'get_unread_messages.dart';







class HitianConnectorConnector {
  
  
  UpsertUserVariablesBuilder upsertUser ({required String id, required String name, required String email, }) {
    return UpsertUserVariablesBuilder(dataConnect, id: id,name: name,email: email,);
  }
  
  
  UpdateProfilePicVariablesBuilder updateProfilePic ({required String id, }) {
    return UpdateProfilePicVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetUserVariablesBuilder getUser ({required String id, }) {
    return GetUserVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListUsersVariablesBuilder listUsers () {
    return ListUsersVariablesBuilder(dataConnect, );
  }
  
  
  ListAllUsersVariablesBuilder listAllUsers () {
    return ListAllUsersVariablesBuilder(dataConnect, );
  }
  
  
  CreateIdeaVariablesBuilder createIdea ({required String title, required String description, required String category, required String authorId, }) {
    return CreateIdeaVariablesBuilder(dataConnect, title: title,description: description,category: category,authorId: authorId,);
  }
  
  
  VoteIdeaVariablesBuilder voteIdea ({required String ideaId, required String userId, required String type, }) {
    return VoteIdeaVariablesBuilder(dataConnect, ideaId: ideaId,userId: userId,type: type,);
  }
  
  
  AddCriticismVariablesBuilder addCriticism ({required String ideaId, required String userId, required String content, }) {
    return AddCriticismVariablesBuilder(dataConnect, ideaId: ideaId,userId: userId,content: content,);
  }
  
  
  DeleteIdeaVariablesBuilder deleteIdea ({required String id, }) {
    return DeleteIdeaVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateIdeaStatusVariablesBuilder updateIdeaStatus ({required String id, required String status, }) {
    return UpdateIdeaStatusVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  ListIdeasVariablesBuilder listIdeas () {
    return ListIdeasVariablesBuilder(dataConnect, );
  }
  
  
  ListCriticismsVariablesBuilder listCriticisms ({required String ideaId, }) {
    return ListCriticismsVariablesBuilder(dataConnect, ideaId: ideaId,);
  }
  
  
  ListTasksVariablesBuilder listTasks () {
    return ListTasksVariablesBuilder(dataConnect, );
  }
  
  
  CreateTaskVariablesBuilder createTask ({required String text, required String assigneeId, required String senderId, required Timestamp deadline, required String groupId, }) {
    return CreateTaskVariablesBuilder(dataConnect, text: text,assigneeId: assigneeId,senderId: senderId,deadline: deadline,groupId: groupId,);
  }
  
  
  UpdateTaskStatusVariablesBuilder updateTaskStatus ({required String id, required String status, }) {
    return UpdateTaskStatusVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  ListEventsVariablesBuilder listEvents () {
    return ListEventsVariablesBuilder(dataConnect, );
  }
  
  
  ListEventsByAttendeeVariablesBuilder listEventsByAttendee ({required String userId, }) {
    return ListEventsByAttendeeVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  CreateEventVariablesBuilder createEvent ({required String title, required String category, required Timestamp dateTime, required String senderId, required String groupId, }) {
    return CreateEventVariablesBuilder(dataConnect, title: title,category: category,dateTime: dateTime,senderId: senderId,groupId: groupId,);
  }
  
  
  AttendEventVariablesBuilder attendEvent ({required String eventId, required String userId, }) {
    return AttendEventVariablesBuilder(dataConnect, eventId: eventId,userId: userId,);
  }
  
  
  ListEventsByGroupVariablesBuilder listEventsByGroup () {
    return ListEventsByGroupVariablesBuilder(dataConnect, );
  }
  
  
  UnattendEventVariablesBuilder unattendEvent ({required String eventId, required String userId, }) {
    return UnattendEventVariablesBuilder(dataConnect, eventId: eventId,userId: userId,);
  }
  
  
  ListMessagesVariablesBuilder listMessages ({required String groupId, }) {
    return ListMessagesVariablesBuilder(dataConnect, groupId: groupId,);
  }
  
  
  CreateMessageVariablesBuilder createMessage ({required String groupId, required String senderId, required String text, }) {
    return CreateMessageVariablesBuilder(dataConnect, groupId: groupId,senderId: senderId,text: text,);
  }
  
  
  UpdateMessageVariablesBuilder updateMessage ({required String id, required String text, }) {
    return UpdateMessageVariablesBuilder(dataConnect, id: id,text: text,);
  }
  
  
  DeleteMessageVariablesBuilder deleteMessage ({required String id, }) {
    return DeleteMessageVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertLastReadVariablesBuilder upsertLastRead ({required String groupId, required String userId, }) {
    return UpsertLastReadVariablesBuilder(dataConnect, groupId: groupId,userId: userId,);
  }
  
  
  GetLastReadVariablesBuilder getLastRead ({required String groupId, required String userId, }) {
    return GetLastReadVariablesBuilder(dataConnect, groupId: groupId,userId: userId,);
  }
  
  
  AddReactionVariablesBuilder addReaction ({required String messageId, required String userId, required String emoji, }) {
    return AddReactionVariablesBuilder(dataConnect, messageId: messageId,userId: userId,emoji: emoji,);
  }
  
  
  RemoveReactionVariablesBuilder removeReaction ({required String messageId, required String userId, }) {
    return RemoveReactionVariablesBuilder(dataConnect, messageId: messageId,userId: userId,);
  }
  
  
  GetUnreadMessagesVariablesBuilder getUnreadMessages ({required String groupId, required Timestamp lastRead, }) {
    return GetUnreadMessagesVariablesBuilder(dataConnect, groupId: groupId,lastRead: lastRead,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'hitian_connector',
    'hitian_inside_service',
  );

  HitianConnectorConnector({required this.dataConnect});
  static HitianConnectorConnector get instance {
    
    return HitianConnectorConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
