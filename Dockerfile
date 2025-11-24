# Étape 1 — Utiliser l'image officielle Nginx
FROM nginx:alpine

# Étape 2 — Supprimer la page par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Étape 3 — Copier ton CV dans le répertoire web de Nginx
COPY index.html /usr/share/nginx/html/index.html

# Étape 4 — Modifier le port d'écoute dans la conf Nginx
RUN sed -i 's/listen       80;/listen       81;/' /etc/nginx/conf.d/default.conf

# Étape 5 — Exposer le nouveau port
EXPOSE 81

# Étape 6 — Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
