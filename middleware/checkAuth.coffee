import verifyAccessToken from '~/modules/verifyAccessToken'

#: Set Logged Out State

setLoggedOut = (store, redirect) ->
	store.dispatch(
		'auth/setState',
		username: ''
		accessToken: ''
		remember: false
		loggedIn: false
		session: true
	)
	store.dispatch(
		'nav/setState',
		showSignout: false
	)
	return redirect('/account/login')

#: Auth Verification

export default ({ app, store, route, redirect }) ->

	try

		# Get Current Path

		curPath = route.name.split('-')

		# Account Routes

		if curPath[0] == 'account' and ['login', 'signup'].includes(curPath[1])

			# Check if already logged in

			if store.state.auth.loggedIn
				store.dispatch(
					'nav/setState',
					showLogin: false
					showSignup: false
					showSignout: true
				)
				return redirect('/')

			# Show/hide auth nav buttons if not logged in

			else

				# Login page

				if curPath[1] == 'login'
					store.dispatch(
						'nav/setState',
						showLogin: false
						showSignup: true
						showSignout: false
					)

				# Signup page

				else if curPath[1] == 'signup'
					store.dispatch(
						'nav/setState',
						showLogin: true
						showSignup: false
						showSignout: false
					)

		# Authenticated Routes

		else

			# Check if logged out

			if !store.state.auth.loggedIn
				return setLoggedOut(store, redirect)

			# No remember - check if new session

			else if (store.state.auth.loggedIn and !store.state.auth.remember and
				(!store.state.auth.session? || !store.state.auth.session))
					return setLoggedOut(store, redirect)

			# Check if token is valid

			else
				if app.$api.setAuthToken(store.state.auth.accessToken)
					res = await verifyAccessToken.bind(app)()
					if !res.status
						return setLoggedOut(store, redirect)

					else if res.status and res.refreshToken?

						# Set access token and initiate new session if not present

						if (!store.state.auth.session)
							store.dispatch(
								'auth/setState',
								session: true
								accessToken: res.refreshToken
							)
						else
							store.dispatch(
								'auth/setState',
								accessToken: res.refreshToken
							)

						# Show signout button

						if (!store.state.nav.showSignout)
							store.dispatch(
								'nav/setState',
								showSignout: true
							)

	catch error
		console.log(error)

#::: End Program :::