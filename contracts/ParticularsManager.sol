// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./DocumentsManager.sol";
import "./OrganisationsManager.sol";
import "./RequestsManager.sol";

contract ParticularsManager {
    address public owner;
    OrganisationsManager public orgContract;
    DocumentsManager public docContract;
    RequestsManager public reqManager;
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
        function setDocContract(address addr) external onlyOwner {
        docContract = DocumentsManager(addr);
    }
    function setReqContract(address addr) external onlyOwner {
        reqManager = RequestsManager(addr);
    }
    struct Particular {
        address particularAddress;
        string username;
        address[] favouriteOrgs;
        uint256[] documentRequestsSended;
        uint256[] documentRequestsReceived;
        
        uint256[] documents;
    }

    mapping(address => Particular) public particulars;


    modifier onlyParticular() {
    require(
      bytes(particulars[msg.sender].username).length != 0,
      "Only particulars can call this function"
    );
    _;
  }
    function addParticular(address _particularAddress, string memory _name)
    external
    {
        particulars[_particularAddress].username = _name;
        particulars[_particularAddress].particularAddress = _particularAddress;
    }


    function addFavouriteOrg(address _orgAddress) external onlyParticular {
        particulars[msg.sender].favouriteOrgs.push(_orgAddress);
    }
    function removeFavouriteOrg(address _orgAddress) external onlyParticular {
        address[] storage favouriteOrgs = particulars[msg.sender].favouriteOrgs;
        for (uint256 i = 0; i < favouriteOrgs.length; i++) {
            if (favouriteOrgs[i] == _orgAddress) {
                favouriteOrgs[i] = favouriteOrgs[favouriteOrgs.length - 1];
                favouriteOrgs.pop();
                return;
            }
        }
        revert("Organization not found in favourites");
    }
    function addDocRequestSended(uint256 requestId,address particularAddress) external {
        particulars[particularAddress].documentRequestsSended.push(requestId);
    }
    function addDocToParticular(uint256 docId, address _particularAddress) external {
            particulars[_particularAddress].documents.push(docId);
    }

    function getParticular(address _orgAddress) external view returns (Particular memory) {
        return particulars[_orgAddress];
    }

    function getParticularDocuments(address _particularAddress) external view returns (DocumentsManager.DocumentDTO[] memory) {
        uint256[] memory partDocIds = particulars[_particularAddress].documents;
        DocumentsManager.DocumentDTO[] memory res = new DocumentsManager.DocumentDTO[](partDocIds.length);
        for(uint256 i = 0 ; i<partDocIds.length;i++){
            res[i] = docContract.getDocumentDTO(partDocIds[i]);
        }
        return res;
    }


    function getAllParticularDocuments() external view returns (DocumentsManager.DocumentDTO[] memory) {
        DocumentsManager.DocumentDTO[] memory res = new DocumentsManager.DocumentDTO[](docContract.nextDocumentId());
        for(uint256 i = 0; i< docContract.nextDocumentId(); i++){
            res[i] = docContract.getDocumentDTO(i);
        }
        return res;
    }
    function getParticularDocRequests() external onlyParticular view returns (RequestsManager.DocumentRequestDTO[] memory)  {
        uint256[] memory sendedRequestsId = particulars[msg.sender].documentRequestsSended;
        RequestsManager.DocumentRequestDTO[] memory res = new RequestsManager.DocumentRequestDTO[](sendedRequestsId.length);
        for(uint256 i = 0; i< sendedRequestsId.length; i++){
            res[i] = reqManager.getDocumentRequestDTO(sendedRequestsId[i]);
        }
        return res;
    }
    function getParticularDocGrantRequests() external onlyParticular view returns (RequestsManager.GrantRequestDTO[] memory) {
        uint256[] memory receivedRequestsId = particulars[msg.sender].documentRequestsReceived;
        RequestsManager.GrantRequestDTO[] memory res = new RequestsManager.GrantRequestDTO[](receivedRequestsId.length);
        for(uint256 i = 0; i< receivedRequestsId.length; i++){
            res[i] = reqManager.getGrantRequestDTO(receivedRequestsId[i]);
        }
        return res;
    }

    function getFavouriteOrgs()
    external
    view
    onlyParticular
    returns (OrganisationsManager.Organisation[] memory)
    {
        address[] memory partFavouriteDocAddresses = particulars[msg.sender].favouriteOrgs;
        OrganisationsManager.Organisation[] memory res = new OrganisationsManager.Organisation[](partFavouriteDocAddresses.length);
        for(uint256 i = 0 ; i<partFavouriteDocAddresses.length;i++){
            res[i] = orgContract.getOrganisation(partFavouriteDocAddresses[i]);
        }
        return res;
    }
}
