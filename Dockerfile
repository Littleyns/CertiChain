# Utilisez l'image officielle de Flutter comme base
FROM cirrusci/flutter:latest

# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez les fichiers nécessaires dans le conteneur
COPY . /app

# Exécutez les commandes Flutter nécessaires (par exemple, pour construire l'application)
RUN flutter pub get
RUN flutter build apk

# Commande par défaut pour démarrer l'application (ajustez en fonction de vos besoins)
CMD ["flutter", "run"]
