#!/bin/bash

# Attendre que Ganache démarre (si nécessaire)
sleep 10

# Exécuter truffle develop en arrière-plan
truffle develop &
sleep 10

# Exécuter la migration des contrats
truffle migrate --reset

# Empêcher le conteneur de se terminer immédiatement
while true; do
    sleep 60
done