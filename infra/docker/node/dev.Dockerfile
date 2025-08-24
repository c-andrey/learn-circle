FROM node:lts-alpine

# Instalar pnpm globalmente
RUN npm install -g pnpm

WORKDIR /usr/src/app

# Copiar arquivos do package.json
COPY ./app-node/package.json ./app-node/pnpm-lock.yaml* ./

# Instalar dependências
RUN pnpm install

# Copiar o restante do código
COPY ./app-node .

EXPOSE 3000

CMD ["pnpm", "run", "dev"]
