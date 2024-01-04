1: Télécharger Ganache https://trufflesuite.com/ganache/
2. Télécharger Truffle https://trufflesuite.com/docs/truffle/how-to/install/
2: executer la commande "flutter pub get" pour récupérer les packages nécéssaires à la communication avec
la blockchain notemment web3_dart et http
3: remplacer la variable d'environnement PKEY_SERVER par une clé privée aléatoire que vous trouverez sur ganache en cliquant sur l'icone "Show keys" de l'une des adresses publiques

## Pour remplir la blockchain avec de la data
1: Changer les adresses publiques et privées dans le fichier ./Services/main_fill_mockdata.dart 
par celles présentes sur Ganache

2: éxécuter le fichier
