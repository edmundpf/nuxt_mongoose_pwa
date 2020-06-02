export default function() {

	// Add .coffee extension for store, middleware, etc.

	this.nuxt.options.extensions.push('coffee')
	this.nuxt.hook('build:before', (builder) => {
		builder.supportedExtensions.push('coffee')
	})

	this.extendBuild((config) => {

		// Get babel config from nuxt

		const babel = config.module.rules.find(rule => {
			return String(rule.test) == '/\\.jsx?$/i'
		})

		// Add Coffeescript Loader w/ Babel transpile

		config.module.rules.push({
			test: /\.coffee$/,
			use: [
				babel.use[0],
				{
					loader: 'coffee-loader',
				}
			]
		})

		// Add .coffee extension to webpack

		if (config.resolve.extensions.indexOf('.coffee') === -1) {
			config.resolve.extensions.push('.coffee')
		}
	})
}

//::: End Program :::