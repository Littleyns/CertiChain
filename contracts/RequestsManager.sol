// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./OrganisationsManager.sol";
import "./ParticularsManager.sol";
import "./DocumentsManager.sol";


contract RequestsManager {
    address public owner;
    OrganisationsManager public orgContract;
    ParticularsManager public particularsContract;
    DocumentsManager public docContract;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    function setOrgContract(address addr) external onlyOwner {
        orgContract = OrganisationsManager(addr);
    }
    function setParticularsContract(address addr) external onlyOwner {
        particularsContract = ParticularsManager(addr);
    }
    function setDocContract(address addr) external onlyOwner {
        docContract = DocumentsManager(addr);
    }
    enum DocumentTransactionStatus {
        Pending,
        Approved,
        Rejected
    }

    uint256 public nextDocumentRequestId = 0;
    struct DocumentRequest {
        uint256 docRequestId;
        address recipient;
        address issuer;
        uint256 templateDocId;
        DocumentTransactionStatus status;
    }
    struct DocumentRequestDTO {
        uint256 docRequestId;
        string recipientName;
        string issuerName;
        string templateDocName;
        address recipientAddress;
        address issuerAddress;
        DocumentTransactionStatus status;
    }
    uint256 public nextGrantRequestId = 0;
    struct GrantRequest {
        uint256 grantRequestId;
        address recipient;
        address issuer;
        uint256 docId;
        DocumentTransactionStatus status;
    }
    struct GrantRequestDTO {
        uint256 grantRequestId;
        string recipientName;
        string issuerName;
        DocumentsManager.DocumentDTO doc;
        DocumentTransactionStatus status;
    }
    mapping(uint256 => DocumentRequest) public docRequests; // Demandes de documents d'un particulier à un organisme
    mapping(uint256 => GrantRequest) public grantRequests; // Attributions d'un document par un organisme à un particulier

  modifier onlyOrg() {
    require(
      bytes(orgContract.getOrganisation(msg.sender).name).length != 0,
      "Only organisations can call this function"
    );
    _;
  }
    modifier onlyParticular() {
    require(
      bytes(particularsContract.getParticular(msg.sender).username).length != 0,
      "Only particulars can call this function"
    );
    _;
  }
    function requestDocumentGrant(
        address _particularAddress,
        uint256 _templateDocId,
        string memory description,
        int expirationDate
    ) external onlyOrg { // Demande à un particulier l'attribution d'un document
        // vérifier que la templateDoc existe et qu'il appartient à l'organisation
        // Créez une demande d'attribution
        DocumentsManager.Document memory grantedDoc = docContract.createDocument(_templateDocId, description,_particularAddress, msg.sender,expirationDate );


        GrantRequest memory newRequest = GrantRequest({
        grantRequestId: nextGrantRequestId,
        recipient: _particularAddress,
        issuer: msg.sender,
        docId: grantedDoc.docId,
        status: DocumentTransactionStatus.Pending
        });
        

        // persistence
        orgContract.addDocumentRequestGranted(msg.sender, nextGrantRequestId);
        particularsContract.addDocRequestReceived(nextGrantRequestId,_particularAddress);
        grantRequests[newRequest.grantRequestId] = newRequest;
        nextGrantRequestId++;
        // Émettez un événement pour notifier la demande
        // pas bon event ! emit DocumentGranted(msg.sender, _particularAddress, _templateDocId);


    }

    function acceptDocumentRequest(
        uint256 _docRequestId,
        string memory description,
        int expirationDate

    ) external onlyOrg { // Accepte la requete d'un particulier
        // vérifier que la templateDoc existe et qu'il appartient à l'organisation
        DocumentRequest memory docRequest = docRequests[_docRequestId];
        //Création d'un document à partir du template
        DocumentsManager.Document memory grantedDoc = docContract.createDocument(docRequest.templateDocId, description, docRequest.issuer, msg.sender,expirationDate);


        // Persistence
        particularsContract.addDocToParticular(grantedDoc.docId, docRequest.issuer);
        docRequests[_docRequestId].status = DocumentTransactionStatus.Approved;

        // si le template id correspond changer le status de la requete ou l'effacer
        // Émettre l'événement d'approbation du document
        // pas le bon event creer un event approprié ! emit DocumentGranted(docRequest.recipient, docRequest.issuer, nextDocumentId);
    }
    function rejectDocumentGrant(uint256 _grantRequestId) external onlyParticular {
        GrantRequest storage grantRequest = grantRequests[_grantRequestId];

        // Vérifier que le particulier est le destinataire de la demande
        require(msg.sender == grantRequest.recipient && grantRequest.status == DocumentTransactionStatus.Pending, "bad request");

        // Mettre à jour le statut de la demande d'attribution
        grantRequests[_grantRequestId].status = DocumentTransactionStatus.Rejected;
        // !! effacer le document créé
        // Émettre un événement pour notifier le rejet de la demande
        //emit DocumentGranted(grantRequest.issuer, msg.sender, grantRequest.docId);
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
        orgContract.addDocRequestReceived(newRequest.docRequestId, _orgAddress);
        particularsContract.addDocRequestSended(newRequest.docRequestId, msg.sender);
        docRequests[newRequest.docRequestId] = newRequest;

        // Émettre l'événement de demande de document
        //emit DocumentRequested(msg.sender, _orgAddress, _templateDocId);
    }
    function acceptGrantedDocument(uint256 _grantRequestId)
    external
    onlyParticular
    {
        // vérifier que la templateDoc existe et qu'il appartient à l'organisation
        GrantRequest memory grantRequest = grantRequests[_grantRequestId];

        // Persistence
        grantRequests[_grantRequestId].status = DocumentTransactionStatus.Approved;

        //docContract.transferFromPendingToDelivered(grantRequest.docId);
        particularsContract.addDocToParticular(grantRequest.docId,msg.sender);

        // si le template id correspond changer le status de la requete ou l'effacer
        // Émettre l'événement d'approbation du document
    }
    function rejectDocumentRequest(uint256 _docRequestId) external onlyOrg {
        DocumentRequest storage docRequest = docRequests[_docRequestId];

        // Vérifier que l'organisme est l'émetteur de la demande
        require(msg.sender == docRequest.issuer && docRequest.status == DocumentTransactionStatus.Pending, "bad request");

        // Mettre à jour le statut de la demande d'attribution
        docRequest.status = DocumentTransactionStatus.Rejected;

        // Émettre un événement pour notifier le rejet de la demande
        //emit DocumentRequested(msg.sender, docRequest.recipient, docRequest.templateDocId);
    }

    function getDocumentRequest(uint256 i) external view returns (DocumentRequest memory) {
        return docRequests[i];
    }
    function getDocumentRequestDTO(uint256 i) external view returns (DocumentRequestDTO memory) {
        ParticularsManager.Particular memory p = particularsContract.getParticular(docRequests[i].issuer);
        OrganisationsManager.Organisation memory o = orgContract.getOrganisation(docRequests[i].recipient);
        return  DocumentRequestDTO({docRequestId:docRequests[i].docRequestId,
        recipientName:o.name,
        issuerName: p.username,
        templateDocName:docContract.getTemplateDocument(docRequests[i].templateDocId).name,
        recipientAddress: o.organisationAddress,
        issuerAddress: p.particularAddress,
        status:docRequests[i].status});
    }

    function getGrantRequestDTO(uint256 i) external view returns (GrantRequestDTO memory) {
        return  GrantRequestDTO({grantRequestId:grantRequests[i].grantRequestId,
        recipientName:particularsContract.getParticular(grantRequests[i].recipient).username,
        issuerName: orgContract.getOrganisation(grantRequests[i].issuer).name,
        doc:docContract.getDocumentDTO(grantRequests[i].docId),
        status:grantRequests[i].status});
    }
    function getGrantRequest(uint256 i) external view returns (GrantRequest memory) {
        return grantRequests[i];
    }

}