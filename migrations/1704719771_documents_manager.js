const OrganisationsManager = artifacts.require("OrganisationsManager");
const ParticularsManager = artifacts.require("ParticularsManager");
const DocumentsManager = artifacts.require("DocumentsManager");
const RequestsManager = artifacts.require("RequestsManager");

module.exports = async function (deployer, network, accounts) {
  // Deploy OrganisationsManager
  await deployer.deploy(OrganisationsManager);
  const orgManager = await OrganisationsManager.deployed();

  // Deploy ParticularsManager
  await deployer.deploy(ParticularsManager);
  const particularManager = await ParticularsManager.deployed();

  // Deploy DocumentsManager
  await deployer.deploy(DocumentsManager);
  const docManager = await DocumentsManager.deployed();

  // Deploy RequestsManager and pass addresses of other contracts
    await deployer.deploy(RequestsManager);
    const requestsManager = await RequestsManager.deployed();

  // Call setOrgContract and setDocContract functions
  await requestsManager.setOrgContract(orgManager.address);
  await requestsManager.setDocContract(docManager.address);
  await requestsManager.setParticularsContract(particularManager.address);

    await docManager.setOrgContract(orgManager.address);
    await docManager.setParticularsContract(particularManager.address);

    await particularManager.setOrgContract(orgManager.address);
    await particularManager.setDocContract(docManager.address);
    await particularManager.setReqContract(requestsManager.address);

    await orgManager.setReqsContract(requestsManager.address);
    await orgManager.setDocContract(docManager.address);


    const serverAccount = accounts[0];
  // Création d'organisations
  var adressePubliqueOrganisation = "0xA16842b28FF96Ec695008996F0D85BE705A2c4Dd";
  var adressePriveeOrganisation = "0xf0906fd865d515fed0f4563175bfc5da0eb44cce630fac63a8ede30816d2e6ed";
  var organisationAccount = web3.eth.accounts.privateKeyToAccount(adressePriveeOrganisation).address;
  await orgManager.addOrganisation(adressePubliqueOrganisation,1,"3il",{ from: serverAccount });


  // Création organisation 2
  var adressePubliqueOrganisation2 = "0x92D957b5F34317070E2dAbbA66A77503f5995221";
  var adressePriveeOrganisation2 = "0x1cb8a2d2a75747f0be56180619ba1aaf0ab74c72e7c1892758d210cbf36742e2";
  var organisation2Account = web3.eth.accounts.privateKeyToAccount(adressePriveeOrganisation2).address;
  await orgManager.addOrganisation(adressePubliqueOrganisation2,0,"Consulat X",{ from: serverAccount });

  // Creation particulier toto
  var adressePubliqueParticulier = "0x0df08E74FFd70cd5D4C28D5bA6261755040E69d1";
  var adressePriveeParticulier = "0x3537081c99dff4618e1f3de8382912a1d7ccf651ade0e015b45b79cf25808384";
  var particulierAccount = web3.eth.accounts.privateKeyToAccount(adressePriveeParticulier).address;
  await particularManager.addParticular(adressePubliqueParticulier, "toto",{ from: serverAccount });

  await docManager.createTemplateDocument(adressePubliqueOrganisation,"Diplome d'ingénieur",{ from: organisationAccount });
  await docManager.createTemplateDocument(adressePubliqueOrganisation,"Master spécialisé en big data",{ from: organisationAccount });
  await docManager.createTemplateDocument(adressePubliqueOrganisation,"Master spécialisé cybsecurité",{ from: organisationAccount });
  await docManager.createTemplateDocument(adressePubliqueOrganisation,"Master spécialisé en IOT",{ from: organisationAccount });
  await docManager.createTemplateDocument(adressePubliqueOrganisation,"Master spécialisé développement web",{ from: organisationAccount });
  await docManager.createTemplateDocument(adressePubliqueOrganisation,"Master spécialisé en infrastructures & réseaux",{ from: organisationAccount });

    // Organisation 2 creation template dcuments
  await docManager.createTemplateDocument(adressePubliqueOrganisation2,"Visa long séjour",{ from: organisation2Account });
  await docManager.createTemplateDocument(adressePubliqueOrganisation2,"Visa court séjour",{ from: organisation2Account });
  await docManager.createTemplateDocument(adressePubliqueOrganisation2,"Passeport Talent",{ from: organisation2Account });
  await docManager.createTemplateDocument(adressePubliqueOrganisation2,"Passeport diplomatique",{ from: organisation2Account });



  // Récupération des documents de l'organisation
  var templateDocuments = await orgManager.getOrgTemplateDocuments(adressePubliqueOrganisation);
  console.log(templateDocuments);
  var diplomeInge = templateDocuments[0];
  var masterSpecialise= templateDocuments[1];
  var masterCyber= templateDocuments[2];
  var masterReseau = templateDocuments[5]

  // Récupération des documents de l'organisme 2
  var templateDocuments2 = await orgManager.getOrgTemplateDocuments(adressePubliqueOrganisation2);
  console.log(templateDocuments2);
  var visaCourt = templateDocuments2[1];
  var visaLong = templateDocuments2[0];
    console.log("visacourtId"+visaCourt[0]);
    console.log("visaLongId"+visaLong[0]);


  //Demande d'un document par toto à un organisme
  await requestsManager.requestDocument(adressePubliqueOrganisation,diplomeInge.id,{ from: particulierAccount });
  console.log("Document requested from toto to 3iL");

  //Demande d'un document par toto à un organisme
  await requestsManager.requestDocument(adressePubliqueOrganisation,masterSpecialise.id,{ from: particulierAccount });
  console.log("Document requested from toto to 3iL");

// Récuperer les requetes d'un organisme
var docRequests = await orgManager.getOrgRequestsReceived(adressePubliqueOrganisation,{ from: organisationAccount });
  for(docRequest of docRequests){
    await requestsManager.acceptDocumentRequest(docRequest.docRequestId, "well deserved doc", -1,{ from: organisationAccount }); // changer l'id, récuperer toutes les requetes d'un utilisateur
    console.log("Document accepted from organisation");
  }

    //Demande d'un document par toto à un organisme
    await requestsManager.requestDocument(adressePubliqueOrganisation,masterReseau.id,{ from: particulierAccount });
    console.log("master spécialisé en Reseau requested from toto to 3iL");

  // 3il offre un master specialisé en cyber securité à toto
    await requestsManager.requestDocumentGrant(adressePubliqueParticulier,masterCyber.id,"bien merité certifié owasp",-1,{ from: organisationAccount });
    console.log("3il granted master spécialisé to toto");

    // Consulat X offre un visa de long séjour et un visa de court séjour à toto
    await requestsManager.requestDocumentGrant(adressePubliqueParticulier,visaLong[0],"Autorisé à travailler à titre accessoire",Date.parse("2025-01-01T00:00:00Z"),{ from: organisation2Account });
    console.log("consulat X granted visa long sejour to toto");
    await requestsManager.requestDocumentGrant(adressePubliqueParticulier,visaCourt[0],"Touristique uniquement",Date.parse("2021-01-01T00:00:00Z"),{ from: organisation2Account });
    console.log("consulat X granted visa court sejour to toto");

    // Récuperer les requetes grant émises par les organisme pour toto
    var grantRequests = await particularManager.getParticularDocGrantRequests({ from: particulierAccount });
    console.log(grantRequests);
    // Acceptation du visa court séjour et du master par toto
    await requestsManager.acceptGrantedDocument(grantRequests[0].grantRequestId,{ from: particulierAccount });
    await requestsManager.acceptGrantedDocument(grantRequests[1].grantRequestId,{ from: particulierAccount });


    // toto add 3il to favourite orgs
      await particularManager.addFavouriteOrg(adressePubliqueOrganisation,{ from: particulierAccount });
      await particularManager.addFavouriteOrg(adressePubliqueOrganisation2,{ from: particulierAccount });

  // You can do additional configuration or linking here if needed
};
