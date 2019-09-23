<template>
	<v-data-table
		class="mt-4"
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
						ref="updateDialog"
						buttonText="Create Item"
						:dialogTitle="updateDialogTitle"
						:fields="headers"
						@createClick="createItem()"
					/>
					<infoDialog
						ref="infoDialog"
						:dialogTitle="infoDialogTitle"
						:record="currentRecord"
					/>
			</v-toolbar>
		</template>
		<template v-slot:item.action="{ item }">
			<v-icon
				small
				class="mr-2"
				@click="viewItem(item)"
			>
				mdi-eye
			</v-icon>
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
	import { titleCase, getDateAndTime } from '~/modules/miscUtils'
	import formDialog from '~/components/elements/formDialog'
	import infoDialog from '~/components/elements/infoDialog'
	import validation from '~/mixins/validation'
	cloneDeep = require('lodash.clonedeep')

	export default

		data: ->
			headers = []
			extraFields = [
				{
					text: 'Created'
					value: 'createdAt'
				}
				{
					text: 'Updated'
					value: 'updatedAt'
				}
				{
					text: 'Actions'
					value: 'action'
				}
			]
			model = this.$route.query.model
			headerKeys = Object.keys(models[model].schema)
			for key in headerKeys
				if !appConfig.hiddenFields.includes(key)
					header =
						text: titleCase(key)
						value: key
						model: ''
						rules: []
					if models[model].schema[key].required? and models[model].schema[key].required
						header.required = true
						header.rules.push(this.requiredValidation(header.text))
					else
						header.required = false
					if models[model].encryptFields.includes(key)
						header.show = false
					headers.push(header)
			for field in extraFields
				headers.push(field)

			return
				model: model
				title: titleCase(model)
				headers: headers
				updateDialogTitle: 'Create a Record'
				infoDialogTitle: 'Record #1'
				itemsPerPage: 10
				itemsDisplay: []
				currentRecord: {}
				items: []

		created: ->
			data = await this.$api.getAll(models[this.model].collectionName)
			if data.status == 'ok'
				this.items = cloneDeep(data.response)
				for record in data.response
					for key, val of record
						if !['createdAt', 'updatedAt'].includes(key)
							if val.length >= 31
								record[key] = "#{val.substring(0, 28)}..."
						else
							dateTime = getDateAndTime(val)
							record[key] = "#{dateTime.date} #{dateTime.time}"
				this.itemsDisplay = data.response

		methods:

			# Create Item

			createItem: (item) ->
				for header in this.headers
					header.model = ''

			# View Item

			viewItem: (item) ->
				itemIndex = this.itemsDisplay.indexOf(item)
				this.currentRecord = this.items[itemIndex]
				this.$refs.infoDialog.dialogTitleText = "Record ##{itemIndex + 1}"
				this.$refs.infoDialog.showDelete = false
				this.$refs.infoDialog.showDialog = true

			# Edit Item

			editItem: (item) ->
				itemIndex = this.getItemModels(item)
				this.$refs.updateDialog.dialogTitleText = "Update Record ##{itemIndex + 1}"
				this.$refs.updateDialog.showDialog = true

			# Copy Item

			copyItem: (item) ->
				itemIndex = this.getItemModels(item)
				this.$refs.updateDialog.dialogTitleText = "Copy Record ##{itemIndex + 1}"
				this.$refs.updateDialog.showDialog = true

			# Delete Item

			deleteItem: (item) ->
				itemIndex = this.itemsDisplay.indexOf(item)
				this.currentRecord = this.items[itemIndex]
				this.$refs.infoDialog.dialogTitleText = "Delete Record ##{itemIndex + 1}"
				this.$refs.infoDialog.showDelete = true
				this.$refs.infoDialog.showDialog = true

			# Get Item Models

			getItemModels: (item) ->
				itemIndex = this.itemsDisplay.indexOf(item)
				for key, val of this.items[itemIndex]
					for header in this.headers
						if key == header.value
							header.model = val
				return itemIndex

		mixins: [
			validation
		]

		components: {
			formDialog
			infoDialog
		}


</script>