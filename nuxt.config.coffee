import appConfig from './appConfig.json'
import colors from 'vuetify/es5/util/colors'

module.exports =

	# Render Mode

	mode: 'spa'

	# Page Headers

	head:
		title: appConfig.siteTitle || process.env.npm_package_name || ''
		meta: [
			charset: 'utf-8'
			hid: 'description'
			name: 'description'
			content: appConfig.siteDesc || process.env.npm_package_description || ''
		]

	# Manifest

	manifest:
		name: appConfig.siteTitle || process.env.npm_package_name || ''

	# Web Server

	server:
		port: appConfig.webPort

	# Server Middleware

	serverMiddleware: [
		'~/modules/restApi'
	]

	# Router Middleware

	router:
		middleware: [
			'checkAuth'
		]

	# Modules

	modules: [
		'~/modules/coffeescript'
		[
			'@nuxtjs/pwa'
			oneSignal: false
		]
	]

	# Build Modules

	buildModules: [
		'@nuxtjs/vuetify',
	],

	# Plugins

	plugins: [
		'~/plugins/apiConsumer'
		'~/plugins/persistState'
	]

	# Vuetify

	vuetify:
		customVariables: ['~/assets/scss/variables.scss']
		theme:
			dark: true
			themes: dark:
				primary: colors.purple.darken2
				secondary: colors.pink.darken3
				accent: colors.orange.accent3
				info: colors.cyan.lighten1
				warning: colors.amber.lighten1
				error: colors.red.accent3
				success: colors.green.accent4

	# CSS

	css: [
		src: '~/assets/scss/styles.scss'
		lang: 'scss'
	]

	# Loading Bar Color

	loading:
		color: colors.orange.accent3

	# Build Config

	build:

		analyze: process.env.NODE_ENV == 'production'

		# Webpack Extension

		extend: (config, ctx) ->

#::: End Program :::