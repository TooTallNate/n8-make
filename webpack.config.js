module.exports = {
  module: {
    preLoaders: [
      {
        test: /\.js$/,
        loader: require.resolve('source-map-loader')
      }
    ],
    loaders: [
      {
        test: /\.json/,
        loader: require.resolve('json-loader')
      }
    ]
  }
};
