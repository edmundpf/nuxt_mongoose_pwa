startCase = require('lodash.startcase')
camelCase = require('lodash.camelcase')

#: Title Case

export titleCase = (text) ->
	return startCase(camelCase(text))

#::: End Program :::