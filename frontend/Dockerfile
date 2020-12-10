FROM node:14
WORKDIR /doit
COPY package.json yarn.lock /doit/
RUN yarn install
COPY . .
CMD ["yarn", "run", "start"]