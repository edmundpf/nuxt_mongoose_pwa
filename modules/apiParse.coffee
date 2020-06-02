#: Get Error Message

export errorMessage = (res) ->
	if res.response.message?
		return res.response.message
	else if res.response.messages?
		return res.response.messages.join(' ')

#::: End Program :::