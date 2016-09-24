// Webpack has its own configuration for module resolution.
// Let's make it mimic how `NODE_PATH` works.
var modulesDirectories = process.env.NODE_PATH.split(':');
var i;
while (-1 !== (i = modulesDirectories.indexOf(''))) {
  modulesDirectories.splice(i, 1);
}
if (-1 === modulesDirectories.indexOf('node_modules')) {
  modulesDirectories.push('node_modules');
}

module.exports = {
  resolve: {
    modulesDirectories: modulesDirectories
  },
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
  },
  debug: true,
  devtool: 'source-map'
};
