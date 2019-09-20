# Set Access Token

export default () ->
	res = await this.$api.verifyToken()
	try
		refreshToken = res.refresh_token.access_token
	catch
		refreshToken = null

	if res.status == 'ok'
		return {
			status: true
			refreshToken
		}
	else if res.status == 'error'
		return {
			status: false
			refreshToken
		}

#::: End Program :::