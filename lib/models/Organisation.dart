enum Domain {
  Government,
  Education,
  Banking
}
class Organisation {
  String orgAddress; // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String name;
  Domain domain;

  Organisation({required this.orgAddress, required this.name, required this.domain});
}
