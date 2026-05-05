library;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'upsert_user.dart';

part 'update_profile_pic.dart';

part 'get_user.dart';







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
