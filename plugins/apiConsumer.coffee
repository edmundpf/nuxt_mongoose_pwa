import Vue from 'vue'
consumer = require('mongoose-auto-api.consumer')
Vue.prototype.$api = new consumer()

#::: End Program :::