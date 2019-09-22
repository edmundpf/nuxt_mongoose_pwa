import Vue from 'vue'
con = require('mongoose-auto-api.consumer')
consumer = new con()

export default ({ app }, inject) =>
	inject('api', consumer)

#::: End Program :::