enum Domain {
  Government,
  Education,
  Banking,

}
Domain domainFromId(String id){
  if (id == "0"){
    return Domain.Government;
  }else if(id=="1"){
    return Domain.Education;
  }else if(id=="2"){
    return Domain.Banking;
  }
  return Domain.Education;
}
class Organisation {
  String orgAddress; // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String name;
  Domain domain;

  Organisation.fromJson(List<dynamic> json)
      : orgAddress = json[0].toString() as String,
        name = json[1].toString() as String,
        domain = domainFromId(json[2].toString());

  Organisation({required this.orgAddress, required this.name, required this.domain});
  @override
  String toString() {
    return "Organisation: ${name} | org Address: ${orgAddress} | domaine activite: ${domain.toString()}"  ;
  }

}


