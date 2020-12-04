module.exports = {
  verbose: true,
  testMatch: [
    "**/__tests__/**/*.test.js"
  ],
  moduleFileExtensions: [
    "js",
    "json",
    "vue"
  ],
  transform: {
    "^.+\\.js$": "babel-jest",
    "^.+\\.vue$": "vue-jest"
  },
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/components/$1"
  }
}