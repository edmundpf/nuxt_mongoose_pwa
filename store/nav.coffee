import store from '~/modules/store/state/nav'
import {
	mutations as universalMutations,
	actions as universalActions,
} from '~/modules/store/methods/universal'

mutations = {
	...universalMutations,
}

actions = {
	...universalActions,
}

state = store.state

export {
	state,
	mutations,
	actions,
}