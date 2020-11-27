const webpack = require('webpack');
const { VueLoaderPlugin } = require("vue-loader");

module.exports = {
  mode: 'production',
  entry: './app/javascript/packs/main.js',
  output: {
    path: __dirname + '/public',
    publicPath: '/',
    filename: 'js/app.js'
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            js: 'babel-loader'
          }
        }
      },
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      },
      {
        test: /\.css$/,
        use: ['vue-style-loader', 'css-loader']
      },
      {
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          {
            loader: 'sass-loader',
          },
        ],
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.vue'],
    alias: {
      'vue$': 'vue/dist/vue.common.js'
    }
  },
  devServer: {
    contentBase: __dirname + '/public',
    publicPath: '/',
    noInfo: true,
    historyApiFallback: true
  },
  plugins: [new VueLoaderPlugin()]
};