startCase = require('lodash.startcase')
camelCase = require('lodash.camelcase')
import { format } from 'date-fns'

#: Title Case

export titleCase = (text) ->
	return startCase(camelCase(text))

#: Get Date/Time

export getDateAndTime = (value, military=false) ->
	date = new Date(value)
	h = date.getHours()
	m = date.getMinutes()
	s = date.getSeconds()
	session = 'AM'
	dd = String(date.getDate()).padStart(2, '0')
	mm = String(date.getMonth() + 1).padStart(2, '0')
	yyyy = date.getFullYear()
	if !military
		if h == 0
			h = 12
		else if h > 12
			h = h - 12
			session = 'PM'
	m = if m < 10 then "0#{m}" else m
	s = if s < 10 then "0#{s}" else s
	if !military
		time = "#{h}:#{m}:#{s} #{session}"
	else
		time = "#{h}:#{m}:#{s}"
	return
		date: "#{yyyy}-#{mm}-#{dd}"
		time: time

#: Round Number

export roundNumber = (number, places=2) ->
	return number.toFixed(places)

#: Get Percent

export getPercent = (val, places=2) ->
	return "#{roundNumber(Number(val) * 100, places)}%"

#: Current Local Date

export currentLocalDate = (curDate) ->
	if !curDate?
		curDate = new Date()
	return new Date("#{format(curDate, 'yyyy-MM-dd')}T00:00:00").toISOString()

#::: End Program :::