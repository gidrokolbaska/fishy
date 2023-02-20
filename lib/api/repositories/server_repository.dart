import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart' as models;

class ServerRepository {
  final Client client;

  late final Account account;
  late final Databases databases;
  ServerRepository(this.client) {
    account = Account(client);
    databases = Databases(client);
  }

  ///This function will create a new Points collection for current user
  Future<String?> createPointsCollection(String currentUserId) async {
    models.Collection? collection;
    try {
      collection = await databases.getCollection(
          databaseId: 'fishydatabase', collectionId: 'pointsof$currentUserId');
    } on AppwriteException catch (e) {
      //if collection doesn't exist, then create one
      if (e.code == 404) {
        collection = await databases.createCollection(
          databaseId: 'fishydatabase',
          collectionId: 'pointsof$currentUserId',
          name: 'Points of: $currentUserId',
          permissions: [
            Permission.read(
              Role.user(currentUserId),
            ),
            Permission.write(
              Role.user(currentUserId),
            ),
          ],
        );
      } else {
        rethrow;
      }
    }

    ///if collection attributes are empty, create them
    if (collection.attributes.isEmpty) {
      await _fillCollectionAttributes(collection.$id);
    }
    return collection.$id;
  }

  Future<void> _fillCollectionAttributes(String collectionId) async {
    try {
      await databases.createStringAttribute(
          databaseId: 'fishydatabase',
          collectionId: collectionId,
          key: "positionName",
          size: 255,
          xrequired: true);
      await databases.createStringAttribute(
          databaseId: 'fishydatabase',
          collectionId: collectionId,
          key: "positionDescription",
          size: 255,
          xrequired: false);
      await databases.createFloatAttribute(
          databaseId: 'fishydatabase',
          collectionId: collectionId,
          key: 'lat',
          xrequired: true);
      await databases.createFloatAttribute(
          databaseId: 'fishydatabase',
          collectionId: collectionId,
          key: 'lon',
          xrequired: true);
    } on AppwriteException catch (e) {
      rethrow;
    }
  }
}
