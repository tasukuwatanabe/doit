const path = require('path');
const { merge } = require('webpack-merge');
const commonConfig = require('./webpack.common.js');

module.exports = merge(commonConfig, {
  mode: 'development',
  watch: true,
  devtool: 'eval-cheap-module-source-map',
  devServer: {
    port: 8080,
    contentBase: path.resolve(__dirname, 'public'),
  },
});