#!/bin/bash

# Attendre que Ganache démarre (optionnel)
sleep 10

# Exécuter truffle develop en arrière-plan
truffle develop &

# Attendre que truffle develop démarre (vous pouvez ajuster ce délai)
sleep 10

# Exécuter la migration des contrats
truffle migrate --reset
