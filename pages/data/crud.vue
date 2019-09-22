<template>
	<v-data-table
		:headers="headers"
		:items="itemsDisplay"
		:items-per-page="itemsPerPage"
	/>
</template>

<script lang="coffee">

	import appConfig from '~/appConfig.json'
	import models from '~/assets/json/models.json'
	import { titleCase } from '~/modules/miscUtils'
	cloneDeep = require('lodash.clonedeep')

	export default

		data: ->
			headers = []
			model = this.$route.query.model
			headerKeys = Object.keys(models[model].schema)
			for key in headerKeys
				if !appConfig.hiddenFields.includes(key)
					headers.push(
						text: titleCase(key)
						value: key
					)
			return
				model: model
				headers: headers
				itemsPerPage: 10
				itemsDisplay: []
				items: []
		mounted: ->
			data = await this.$api.getAll(models[this.model].collectionName)
			if data.status == 'ok'
				this.items = cloneDeep(data.response)
				for record in data.response
					for key, val of record
						if val.length >= 31
							record[key] = "#{val.substring(0, 28)}..."
				this.itemsDisplay = data.response

</script>