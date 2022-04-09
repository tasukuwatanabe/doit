FROM node:14
WORKDIR /doit
COPY package.json yarn.lock /doit/
RUN yarn install
COPY . .
RUN yarn run build
CMD webpack-dev-server --history-api-fallback --port $PORT --config webpack.dev.js