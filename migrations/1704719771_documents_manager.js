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

    await orgManager.setReqsContract(requestsManager.address);
    await orgManager.setDocContract(docManager.address);

  // You can do additional configuration or linking here if needed
};
