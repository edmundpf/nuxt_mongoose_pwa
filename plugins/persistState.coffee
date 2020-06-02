import Cookies from 'js-cookie'
import createPersistedState from 'vuex-persistedstate'
import { persist, session } from '~/modules/store/persist'

#: State Storage

export default ({ store }) ->

	# Persisted Store (7 days)

	createPersistedState(
		paths: persist
		storage:
			removeItem: (key) -> Cookies.remove(key)
			getItem: (key) -> Cookies.get(key)
			setItem: (key, value) -> Cookies.set(
				key,
				value,
				expires: 7,
				secure: false
			)
	)(store)

	# Session Store (cleared after tab close)

	createPersistedState(
		paths: session
		storage: window.sessionStorage
	)(store)

#::: End Program :::