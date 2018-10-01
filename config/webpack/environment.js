const { environment } = require('@rails/webpacker')

if (environment.plugins.getIndex('UglifyJs') !== -1) {
  const plugin = environment.plugins.get('UglifyJs');
  const mangle = plugin.options.uglifyOptions.mangle;
  if (!mangle.reserved) { mangle.reserved = [] }
  // Rickshaw needs this special variable with this exact name to work
  mangle.reserved.push("$super");
}

module.exports = environment
