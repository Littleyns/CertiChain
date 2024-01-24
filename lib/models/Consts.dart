enum DocumentTransactionStatus {
  Pending,
  Approved,
  Rejected,

}
DocumentTransactionStatus statusFromIdentifier(String id){
if (id == "0"){
return DocumentTransactionStatus.Pending;
}else if(id=="1"){
return DocumentTransactionStatus.Approved;
}else if(id=="2"){
return DocumentTransactionStatus.Rejected;
}
return DocumentTransactionStatus.Pending;
}