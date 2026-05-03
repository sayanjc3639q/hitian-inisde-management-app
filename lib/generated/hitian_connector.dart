library hitian_data;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'upsert_user.dart';

part 'update_profile_pic.dart';

part 'get_user.dart';

part 'create_idea.dart';

part 'vote_idea.dart';

part 'add_criticism.dart';

part 'list_ideas.dart';







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
  
  
  CreateIdeaVariablesBuilder createIdea ({required String title, required String description, required String category, required String authorId, }) {
    return CreateIdeaVariablesBuilder(dataConnect, title: title,description: description,category: category,authorId: authorId,);
  }
  
  
  VoteIdeaVariablesBuilder voteIdea ({required String ideaId, required String userId, required String type, }) {
    return VoteIdeaVariablesBuilder(dataConnect, ideaId: ideaId,userId: userId,type: type,);
  }
  
  
  AddCriticismVariablesBuilder addCriticism ({required String ideaId, required String userId, required String content, }) {
    return AddCriticismVariablesBuilder(dataConnect, ideaId: ideaId,userId: userId,content: content,);
  }
  
  
  ListIdeasVariablesBuilder listIdeas () {
    return ListIdeasVariablesBuilder(dataConnect, );
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
