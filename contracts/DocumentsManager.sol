// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract DocumentsManager {
  address public owner;

  enum DocumentTransactionStatus {
    Pending,
    Approved,
    Rejected
  }

  uint256 nextDocumentRequestId = 0;
  struct DocumentRequest {
    uint256 docRequestId;
    address recipient;
    address issuer;
    uint256 templateDocId;
    DocumentTransactionStatus status;
  }

  uint256 nextGrantRequestId = 0;
  struct GrantRequest {
    uint256 grantRequestId;
    address recipient;
    address issuer;
    uint256 docId;
    DocumentTransactionStatus status;
  }

  uint256 nextTemplateDocumentId = 0;
  struct TemplateDocument {
    uint256 id;
    string name;
  }

  uint256 nextDocumentId = 0;
  struct Document {
    uint256 docId;
    TemplateDocument templateDoc;
    string description;

  }
  struct Organisation {
    address organisationAddress;
    string name;
    TemplateDocument[] templateDocuments;
    DocumentRequest[] documentRequestsReceived;
    GrantRequest[] documentRequestsGranted;
  }

  struct Particular {
    address particularAddress;
    string username;
    Organisation[] favouriteOrgs;
    DocumentRequest[] documentRequestsSended;
    GrantRequest[] documentRequestsReceived;
    Document[] documents;
  }

  mapping(address => Organisation) public organisations;
  mapping(address => Particular) public particulars;
  mapping(uint256 => TemplateDocument) public templateDocuments;
  mapping(uint256 => Document) public documents;
  mapping(uint256 => DocumentRequest) public docRequests; // Demandes de documents d'un particulier à un organisme
  mapping(uint256 => GrantRequest) public grantRequests; // Attributions d'un document par un organisme à un particulier

  event DocumentCreated(address orgAddress, uint256 docId);

  event DocumentGranted(
    address indexed issuer,
    address indexed recipient,
    uint256 docId
  );
  event DocumentRequested(
    address indexed issuer,
    address indexed recipient,
    uint256 templateDocId
  );

  modifier onlyOrg() {
    require(
      bytes(organisations[msg.sender].name).length != 0,
      "Only organisations can call this function"
    );
    _;
  }
  modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
  }
  modifier onlyParticular() {
    require(
      bytes(particulars[msg.sender].username).length != 0,
      "Only particulars can call this function"
    );
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function addParticular(address _particularAddress, string memory _username)
  external
  {
    // vérifier la signature de la transaction
    particulars[_particularAddress].username = _username;
    particulars[_particularAddress].particularAddress = _particularAddress;
  }
  function addOrganisation(address _orgAddress, string memory _name)
  external
  onlyOwner
  {
    organisations[_orgAddress].name = _name;
    organisations[_orgAddress].organisationAddress = _orgAddress;
  }

  function addFavouriteOrg(address _orgAddress) external onlyParticular {
    particulars[msg.sender].favouriteOrgs.push(organisations[_orgAddress]);
  }

  // Organisations Scope functions
  function createTemplateDocument(address _orgAddress, string memory _name)
  external
  onlyOrg
  {
    TemplateDocument memory newTemplateDocument = TemplateDocument({
    name: _name,
    id:  nextTemplateDocumentId
    });
    nextTemplateDocumentId++;


    // persistence
    organisations[_orgAddress].templateDocuments.push(newTemplateDocument);
    templateDocuments[newTemplateDocument.id] = newTemplateDocument;

    emit DocumentCreated(msg.sender, newTemplateDocument.id);

  }


  function requestDocumentGrant(
    address _particularAddress,
    uint256 _templateDocId
  ) external onlyOrg { // Demande à un particulier l'attribution d'un document
    // vérifier que la templateDoc existe et qu'il appartient à l'organisation
    // Créez une demande d'attribution
    Document memory grantedDoc = Document({
    docId: nextDocumentId,
    templateDoc: templateDocuments[_templateDocId],
    description: "haha this is a document"
    });
    nextDocumentId++;

    GrantRequest memory newRequest = GrantRequest({
    grantRequestId: nextGrantRequestId,
    recipient: _particularAddress,
    issuer: msg.sender,
    docId: nextDocumentId,
    status: DocumentTransactionStatus.Pending
    });
    nextGrantRequestId++;

    // persistence
    organisations[msg.sender].documentRequestsGranted.push(newRequest);
    particulars[_particularAddress].documentRequestsReceived.push(newRequest);
    grantRequests[newRequest.grantRequestId] = newRequest;
    documents[grantedDoc.docId] = grantedDoc;

    // Émettez un événement pour notifier la demande
    // pas bon event ! emit DocumentGranted(msg.sender, _particularAddress, _templateDocId);


  }

  function acceptDocumentRequest(
    address _particularAddress,
    uint256 _docRequestId
  ) external onlyOrg { // Accepte la requete d'un particulier
    // vérifier que la templateDoc existe et qu'il appartient à l'organisation
    DocumentRequest memory docRequest = docRequests[_docRequestId];
    //Création d'un document à partir du template
    Document memory grantedDoc = Document({
    docId: nextDocumentId,
    templateDoc: templateDocuments[docRequest.templateDocId],
    description: "haha this is a document"
    });
    nextDocumentId++;

    //Création d'une requete d'attribution
    GrantRequest memory newRequest = GrantRequest({
    grantRequestId: nextGrantRequestId,
    recipient: _particularAddress,
    issuer: msg.sender,
    docId: grantedDoc.docId,
    status: DocumentTransactionStatus.Approved
    });
    nextGrantRequestId++;

    // Persistence
    organisations[msg.sender].documentRequestsGranted.push(newRequest);
    particulars[_particularAddress].documentRequestsReceived.push(newRequest);
    particulars[_particularAddress].documents.push(grantedDoc);
    grantRequests[newRequest.grantRequestId] = newRequest;
    documents[grantedDoc.docId] = grantedDoc;
    docRequest.status = DocumentTransactionStatus.Approved;

    // si le template id correspond changer le status de la requete ou l'effacer
    // Émettre l'événement d'approbation du document
    // pas le bon event creer un event approprié ! emit DocumentGranted(docRequest.recipient, docRequest.issuer, nextDocumentId);
  }
  function rejectDocumentGrant(uint256 _grantRequestId) external onlyParticular {
    GrantRequest storage grantRequest = grantRequests[_grantRequestId];

    // Vérifier que le particulier est le destinataire de la demande
    require(msg.sender == grantRequest.recipient, "You are not the recipient of this document grant");

    // Vérifier que la demande est en attente
    require(grantRequest.status == DocumentTransactionStatus.Pending, "Document grant is not pending");

    // Mettre à jour le statut de la demande d'attribution
    grantRequest.status = DocumentTransactionStatus.Rejected;

    // Émettre un événement pour notifier le rejet de la demande
    emit DocumentGranted(grantRequest.issuer, msg.sender, grantRequest.docId);
  }

  // Particulars Scope functions
  function requestDocument(address _orgAddress, uint256 _templateDocId)
  external
  onlyParticular
  {
    // vérifier que la templateDoc existe et qu'il appartient à l'organisation
    // Créez une demande d'attribution
    DocumentRequest memory newRequest = DocumentRequest({
    docRequestId: nextDocumentRequestId,
    recipient: _orgAddress,
    issuer: msg.sender,
    templateDocId: _templateDocId,
    status: DocumentTransactionStatus.Pending
    });
    nextDocumentRequestId++;

    // Persistence
    organisations[_orgAddress].documentRequestsReceived.push(newRequest);
    particulars[msg.sender].documentRequestsSended.push(newRequest);
    docRequests[newRequest.docRequestId] = newRequest;

    // Émettre l'événement de demande de document
    emit DocumentRequested(msg.sender, _orgAddress, _templateDocId);
  }
  function acceptGrantedDocument(uint256 _grantRequestId)
  external
  view
  onlyParticular
  {
    // vérifier que la templateDoc existe et qu'il appartient à l'organisation
    GrantRequest memory grantRequest = grantRequests[_grantRequestId];

    // Persistence
    grantRequest.status = DocumentTransactionStatus.Approved;

    // si le template id correspond changer le status de la requete ou l'effacer
    // Émettre l'événement d'approbation du document
  }
  function rejectDocumentRequest(uint256 _docRequestId) external onlyOrg {
    DocumentRequest storage docRequest = docRequests[_docRequestId];

    // Vérifier que l'organisme est l'émetteur de la demande
    require(msg.sender == docRequest.issuer, "You are not the issuer of this document request");

    // Vérifier que la demande est en attente
    require(docRequest.status == DocumentTransactionStatus.Pending, "Document request is not pending");

    // Mettre à jour le statut de la demande d'attribution
    docRequest.status = DocumentTransactionStatus.Rejected;

    // Émettre un événement pour notifier le rejet de la demande
    emit DocumentRequested(msg.sender, docRequest.recipient, docRequest.templateDocId);
  }


  // Getters

  function getOrgTemplateDocuments(address _orgAddress) external view returns (TemplateDocument[] memory) {
    return organisations[_orgAddress].templateDocuments;
  }

  function getFavouriteOrgs()
  external
  view
  onlyParticular
  returns (Organisation[] memory)
  {
    return particulars[msg.sender].favouriteOrgs;
  }

  // Add functions for user to request and approve documents
}
