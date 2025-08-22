# Usa imagem Node.js leve
FROM node:lts-alpine

# Define diretório de trabalho
WORKDIR /usr/src/app

# Copia apenas manifests primeiro
COPY ./app-node/package*.json ./

# Instala dependências de produção
RUN if [ -f package-lock.json ]; then npm ci --only=production; else npm install --omit=dev; fi

# Copia o restante do código
COPY ./app-node .

# Expõe a porta
EXPOSE 3000

# Comando padrão para produção
# Compila o TypeScript para JavaScript
RUN npm run build

# Expõe a porta
EXPOSE 3000

# Comando padrão para produção
CMD ["node", "dist/app.js"]
