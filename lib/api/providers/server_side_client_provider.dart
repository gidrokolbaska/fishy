//TODO: change selfsigned to false
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as serverappwrite;

final dartClientProvider = Provider<serverappwrite.Client>((ref) {
  return serverappwrite.Client()
      .setEndpoint('http://192.168.0.101/v1') // Your Appwrite Endpoint
      .setProject('63dd026b480ab089a636') // Your project ID
      .setKey(
          'f22c98dfb637f4441b1ebae31792df7a7f6ea822e54d90ebdee9c2a0502e25793b9c247d951377a577d667d2aa7379db4ca3e43294e7e72bd355f72a2e1e46dd5a7551a3a7644122d635b2269ea9fdbf0e5e70c28e41be6fd44b3e8b8eee4a9626eb22ee5edaf007ed9aa916bf874a9958a88f1bef5e60483f3e0b3e825f2161') //API key for server side
      .setSelfSigned();
});
