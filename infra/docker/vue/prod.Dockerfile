# Dockerfile.prod
FROM node:lts-alpine

WORKDIR /app

COPY ./app-vue/package*.json ./

# Instalar dependências de produção
RUN npm install

COPY ./app-vue .

RUN npm run build

EXPOSE 4173

CMD ["npm", "run", "preview", "--", "--host"]
