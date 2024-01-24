// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./DocumentsManager.sol";
import "./RequestsManager.sol";

contract OrganisationsManager {
    address public owner;
    DocumentsManager public docContract;
    RequestsManager public reqsContract;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    function setDocContract(address addr) external onlyOwner {
        docContract = DocumentsManager(addr);
    }
    function setReqsContract(address addr) external onlyOwner {
        reqsContract = RequestsManager(addr);
    }
    enum Domains {
        Government,
        Education,
        Banking
    }
    struct Organisation{
        address organisationAddress;
        string name;
        Domains domain;
        uint256[] templateDocuments;
        uint256[] documentRequestsReceived;
        uint256[] documentRequestsGranted;
    }

    mapping(address => Organisation) public organisations;

    mapping(address => uint256[]) public documentsByOrganism;
    Organisation[] public allOrganisations;


    function addOrganisation(address _orgAddress,Domains _domain, string memory _name)
    external
    onlyOwner
    {
        organisations[_orgAddress].name = _name;
        organisations[_orgAddress].organisationAddress = _orgAddress;
        organisations[_orgAddress].domain = _domain;
        allOrganisations.push(organisations[_orgAddress]);
    }

    function addDocRequestReceived(uint256 requestId,address orgAddress) external {
        organisations[orgAddress].documentRequestsReceived.push(requestId);
    }

    function addDocumentRequestGranted(address orgAddress, uint256 requestId) external {
        organisations[orgAddress].documentRequestsGranted.push(requestId);
    }
    function addTemplateDocumentToOrg(uint256 templateDocId, address orgAddress) external {
        organisations[orgAddress].templateDocuments.push(templateDocId);
    }
    function addDocumentToOrg(uint256 docId, address orgAddress) external {
        documentsByOrganism[orgAddress].push(docId);
    }


    function getOrganisation(address _orgAddress) external view returns (Organisation memory) {
        return organisations[_orgAddress];
    }

    function getOrgTemplateDocuments(address _orgAddress) external view returns (DocumentsManager.TemplateDocument[] memory) {
        uint256[] memory orgTDocIds = organisations[_orgAddress].templateDocuments;
        DocumentsManager.TemplateDocument[] memory res = new DocumentsManager.TemplateDocument[](orgTDocIds.length);
        for(uint256 i=0; i<orgTDocIds.length;i++) {
            res[i] = docContract.getTemplateDocument(orgTDocIds[i]);
        }
        return res;
    }

    function getOrgDocuments(address _orgAddress) external view returns (DocumentsManager.DocumentDTO[] memory) {
        uint256[] memory orgDocIds = documentsByOrganism[_orgAddress];
        DocumentsManager.DocumentDTO[] memory res = new DocumentsManager.DocumentDTO[](orgDocIds.length);
        for(uint256 i=0; i<orgDocIds.length;i++) {
            res[i] = docContract.getDocumentDTO(orgDocIds[i]);
        }
        return res;
    }

    function getAllOrganisations() external view returns (Organisation[] memory) {
        return allOrganisations;
    }
    function getOrgRequestsReceived(address _orgAddress) external view returns(RequestsManager.DocumentRequestDTO[] memory){
        require(
            msg.sender == owner || msg.sender == _orgAddress,
            "bad sender"
        );
        uint256[] memory orgRequestReceivedIds = organisations[msg.sender].documentRequestsReceived;
        RequestsManager.DocumentRequestDTO[] memory res = new RequestsManager.DocumentRequestDTO[](orgRequestReceivedIds.length);
        for(uint256 i = 0 ; i<orgRequestReceivedIds.length;i++){
            res[i] = reqsContract.getDocumentRequestDTO(orgRequestReceivedIds[i]);
        }
        return res;
    }
}
