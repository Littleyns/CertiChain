const DocumentsManager = artifacts.require("DocumentsManager");

module.exports = function (deployer) {
  deployer.deploy(DocumentsManager);
};