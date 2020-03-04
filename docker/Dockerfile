FROM node:lts
COPY ./utn-devops-app /app
WORKDIR /app
RUN npm install -g pm2
RUN npm install
CMD ["pm2-runtime", "start", "./bin/www"]
