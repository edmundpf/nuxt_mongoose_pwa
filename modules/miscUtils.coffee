startCase = require('lodash.startcase')
camelCase = require('lodash.camelcase')

#: Title Case

export titleCase = (text) ->
	return startCase(camelCase(text))

#: Get Date/Time

export getDateAndTime = (value) ->
	date = new Date(value)
	h = date.getHours()
	m = date.getMinutes()
	s = date.getSeconds()
	session = 'AM'
	dd = String(date.getDate()).padStart(2, '0')
	mm = String(date.getMonth() + 1)
	yyyy = date.getFullYear()
	if h == 0
		h = 12
	else if h > 12
		h = h - 12
		session = 'PM'
	m = if m < 10 then "0#{m}" else m
	s = if s < 10 then "0#{s}" else s
	return
		date: "#{mm}-#{dd}-#{yyyy}"
		time: "#{h}:#{m}:#{s} #{session}"

#::: End Program :::