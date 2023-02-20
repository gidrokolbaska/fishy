
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

import '../../models/fishy_user_model.dart';

class UserRepository {
  // We will be getting the instance of client through a provider
  final Client client;

  //  Database object to connect with the database and perform CRUD operations
  late Databases database;

  // Storage object to connect with the storage to upload profile picture
  // late Storage storage;

  // Account object to connect with the account to get the unique user id
  // also to update some details of the user
  late Account account;

  // Initialize the class with the client
  UserRepository(this.client) {
    account = Account(client);
    // storage = Storage(client);
    database = Databases(client);
  }

  /// [addUser]
  /// This method is used to add a new user to the database when you signup
  Future<void> addUser() async {
    // Get the details about the current logged in user
    final user = await account.get();

    try {
      // Additional data of the user will be written in the collection
      await database.createDocument(
          databaseId: 'fishydatabase',
          collectionId: 'users',
          documentId: user.$id,
          data: {
            'id': user.$id,
            'email': user.email,
          },
          permissions: [
            Permission.write(
              Role.user(user.$id),
            ),
          ]);
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
    }
  }

  /// [getCurrentUser]
  /// This method is used to get the current user details
  /// It returns the [FishyUser] object which contains all the details of the user
  ///  We will use this object to display the user details in the Drawer
  Future<FishyUser?> getCurrentUser() async {
    try {
      final user = await account.get();
      final data = await database.getDocument(
          databaseId: 'fishydatabase',
          collectionId: 'users',
          documentId: user.$id);

      return FishyUser.fromMap(data.data);
    } catch (_) {
      rethrow;
    }
  }
}
