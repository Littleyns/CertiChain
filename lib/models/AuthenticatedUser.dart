enum UserType {
  Organisation,
  Particular
}
class AuthenticatedUser { // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String publicKey;
  String privateKey;
  UserType type;
  // Add other properties as needed

  AuthenticatedUser({
    required this.publicKey,
    required this.privateKey,
    required this.type,
  });
}