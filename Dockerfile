# Utilisez l'image Node.js avec Truffle installé
FROM node:18

# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez les fichiers de votre projet dans le conteneur
COPY . .

# Installez Truffle globalement
RUN npm install -g truffle

EXPOSE 8545

# Copiez le script de déploiement dans le conteneur
COPY deploy.sh /app/deploy.sh

# Rendre le script exécutable
RUN chmod +x /app/deploy.sh

# Exécutez le script de déploiement lors du démarrage du conteneur
ENTRYPOINT ["sh", "/app/deploy.sh"]