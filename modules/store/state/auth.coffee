export default
	state: ->
		return
			username: ''
			accessToken: ''
			loggedIn: false
			remember: false
			session: false
	persist: true
	session: [
		'session'
	]