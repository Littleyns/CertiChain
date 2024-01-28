// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./OrganisationsManager.sol";
import "./ParticularsManager.sol";
contract DocumentsManager {
    address public owner;
    OrganisationsManager public orgContract;
    ParticularsManager public particularsContract;
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
    uint256 nextTemplateDocumentId = 0;
    struct TemplateDocument {
        uint256 id;
        string name;
    }

     uint256 public nextDocumentId = 0;
    struct Document {
        uint256 docId;
        uint256 templateDocId;
        string description;
        address particularAddress;
        address organisationAddress;
        int expirationDate;

    }
    struct DocumentDTO {
        uint256 docId;
        string templateDocName;
        string description;
        string organisationName;
        string particularName;
        int expirationDate;
    }
    mapping(uint256 => TemplateDocument) public templateDocuments;
    mapping(uint256 => Document) public documents;
    mapping(uint256 => Document) public pendingToGrant;

  modifier onlyOrg() {
    require(
      bytes(orgContract.getOrganisation(msg.sender).name).length != 0,
      "Only organisations can call this function"
    );
    _;
  }
    function createTemplateDocument(address _orgAddress, string memory _name)
    external
    onlyOrg
    {
        TemplateDocument memory newTemplateDocument = TemplateDocument({
        name: _name,
        id:  nextTemplateDocumentId
        });
        


        // persistence
        orgContract.addTemplateDocumentToOrg(nextTemplateDocumentId, _orgAddress);
        templateDocuments[newTemplateDocument.id] = newTemplateDocument;
        nextTemplateDocumentId++;
        //emit DocumentCreated(msg.sender, newTemplateDocument.id);

    }


    function createDocument(uint256 _templateDocId, string memory _description, address _particularAddress, address _orgAddress, int _expirationDate) public returns(Document memory){
        Document memory newDocument = Document({
        docId: nextDocumentId,
        templateDocId: _templateDocId,
        particularAddress: _particularAddress,
        organisationAddress: _orgAddress,
        description: _description,
        expirationDate: _expirationDate
        });

        //  persistence
        orgContract.addDocumentToOrg(nextDocumentId, _orgAddress);
        documents[nextDocumentId] = newDocument;

        nextDocumentId++;
        return newDocument;
    }
    function createPendingDocument(uint256 _templateDocId, string memory _description, address _particularAddress, address _orgAddress, int _expirationDate) public returns(Document memory){
        Document memory newDocument = Document({
        docId: nextDocumentId,
        templateDocId: _templateDocId,
        particularAddress: _particularAddress,
        organisationAddress: _orgAddress,
        description: _description,
        expirationDate: _expirationDate
        });

        //  persistence

        pendingToGrant[nextDocumentId] = newDocument;

        nextDocumentId++;
        return newDocument;
    }

    function transferFromPendingToDelivered(uint256 docId) public {
        documents[docId] = pendingToGrant[docId];
    }

    function getTemplateDocument(uint256 i) external view returns (TemplateDocument memory) {
        return templateDocuments[i];
    }
    function getDocument(uint256 i) external view returns (Document memory) {
        return documents[i];
    }
    function getDocumentDTO(uint256 i) external view returns (DocumentDTO memory) {
        return DocumentDTO({docId:documents[i].docId, templateDocName:templateDocuments[documents[i].templateDocId].name, description: documents[i].description, organisationName:orgContract.getOrganisation(documents[i].organisationAddress).name, particularName:particularsContract.getParticular(documents[i].particularAddress).username,expirationDate: documents[i].expirationDate});
    }

    function getDocumentsByTemplateName(string memory _templateDocName) external view returns (DocumentDTO[] memory) {
        DocumentDTO[] memory res = new DocumentDTO[](nextDocumentId);
        bytes memory templateDocNameBytes = bytes(_templateDocName);
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < nextDocumentId; i++) {
            TemplateDocument memory tdoc = templateDocuments[documents[i].templateDocId];
            if (keccak256(bytes(tdoc.name)) == keccak256(templateDocNameBytes)) {
                res[resultIndex] = this.getDocumentDTO(i);
                resultIndex++;
            }
        }

        // Redimensionner le tableau pour éliminer les éléments non utilisés
        assembly {
            mstore(res, resultIndex)
        }

        return res;
    }
}
