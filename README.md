# Certichain : blockchain Shcool project for Flutter development
# Node version 18 or above is mandatory ! (for truffle) if you don't have node 18 use nvm to switch to version 18

## To run the app

1. run "flutter pub get"
2. run "npm install" to install node dependencies for backend (ganache-cli + truffle)
3. run "npm run start-dev" to run the blockchain simulation and deploy the smartcontracts to it

   ### To run via web browser (preferred)
   - Ensure that GANACHE_HOST variable at .env is 127.0.0.1
   - start the app in android studio via 

   ### To run via android emulator
   - Ensure that GANACHE_HOST variable at .env is set to 10.0.2.2
   - Start the app with android emulator in android studio
