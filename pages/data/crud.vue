<template>
	<v-data-table
		:headers="headers"
		:items="itemsDisplay"
		:items-per-page="itemsPerPage"
	>
		<template v-slot:top>
			<v-toolbar flat>
				<v-toolbar-title>{{ title }}</v-toolbar-title>
					<v-divider
						class="mx-4"
						inset
						vertical
					/>
					<div class="flex-grow-1"></div>
					<formDialog
						buttonText="Create Item"
						dialogTitle="Create a Record"
						:headers="headers"
					/>
			</v-toolbar>
		</template>
		<template v-slot:item.action="{ item }">
			<v-icon
				small
				class="mr-2"
				@click="editItem(item)"
			>
				mdi-pencil
			</v-icon>
			<v-icon
				small
				class="mr-2"
				@click="copyItem(item)"
			>
				mdi-content-copy
			</v-icon>
			<v-icon
				small
				@click="deleteItem(item)"
			>
				mdi-delete
			</v-icon>
		</template>
	</v-data-table>
</template>

<script lang="coffee">

	import appConfig from '~/appConfig.json'
	import models from '~/assets/json/models.json'
	import { titleCase } from '~/modules/miscUtils'
	import formDialog from '~/components/elements/formDialog'
	cloneDeep = require('lodash.clonedeep')

	export default

		data: ->
			headers = []
			model = this.$route.query.model
			headerKeys = Object.keys(models[model].schema)
			for key in headerKeys
				if !appConfig.hiddenFields.includes(key)
					header =
						text: titleCase(key)
						value: key
						model: ''
					if models[model].schema[key].required? and models[model].schema[key].required
						header.required = true
					else
						header.required = false
					if models[model].encryptFields.includes(key)
						header.show = false
					headers.push(header)
			headers.push(
				text: 'Actions'
				value: 'action'
			)
			return
				model: model
				title: titleCase(model)
				headers: headers
				itemsPerPage: 10
				itemsDisplay: []
				items: []

		created: ->
			data = await this.$api.getAll(models[this.model].collectionName)
			if data.status == 'ok'
				this.items = cloneDeep(data.response)
				for record in data.response
					for key, val of record
						if val.length >= 31
							record[key] = "#{val.substring(0, 28)}..."
				this.itemsDisplay = data.response

		components: {
			formDialog
		}


</script>