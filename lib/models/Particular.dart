import 'Organisation.dart';

class Particular {
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