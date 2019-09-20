omit = require('lodash.omit')

#::: Universal Store Methods :::

#: Mutations

mutations =

	# Mutate State

	mutateState:(state, payload) ->
		for key of payload
			if state[key]?
				state[key] = payload[key]

#: Actions

actions =

	# Set State

	setState: (context, payload) ->
		context.commit('mutateState', payload)

#: Exports

export {
	mutations,
	actions,
}

#::: End Program :::