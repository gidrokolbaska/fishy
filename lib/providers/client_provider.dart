import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO: change selfsigned to false
final clientProvider = Provider<Client>((ref) {
  return Client()
      .setEndpoint('http://192.168.0.101/v1') // Your Appwrite Endpoint
      .setProject('63dd026b480ab089a636') // Your project ID
      .setSelfSigned(); // For self signed certificates, only use for development
});
