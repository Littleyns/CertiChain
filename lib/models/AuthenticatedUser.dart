import 'Organisation.dart';

class Particular { // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String particularAddress;
  String username;
  List<Organisation> favouriteOrgs;
  // Add other properties as needed

  Particular({
    required this.particularAddress,
    required this.username,
    required this.favouriteOrgs,
  });
}