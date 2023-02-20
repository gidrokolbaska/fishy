// NOTE: This has been taken from official Flutter appwrite SDK

class FishyUser {
  /// User ID.
  final String id;

  /// User email address.
  final String email;

  /// User preferences as a key-value object

  FishyUser({
    required this.id,
    required this.email,
  });

  factory FishyUser.fromMap(Map<String, dynamic> map) {
    return FishyUser(
      id: map['id'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
    };
  }
}
