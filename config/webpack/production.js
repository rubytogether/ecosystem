process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

// Rickshaw, even when minified, needs this special variable with this exact name to work
environment.config.optimization.minimizer[0].options.terserOptions.mangle.reserved = ["$super"]

module.exports = environment.toWebpackConfig()
