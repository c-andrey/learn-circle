# Usa imagem Node.js base
FROM node:lts-alpine

# Define diretório de trabalho
WORKDIR /usr/src/app

# Copia os manifests primeiro
COPY ./app-node/package*.json ./

# Instala todas as dependências (incluindo dev) para hot reload
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Copia o restante do código
COPY ./app-node .

# Instala nodemon globalmente
RUN npm install -g nodemon

# Expõe a porta da API
EXPOSE 3000

# Comando de inicialização com hot reload
CMD ["nodemon", "--legacy-watch", "src/index.js"]
