<template>
	<div>
		<alert
			:message="message"
			type="success"
			v-bind:show.sync="showMessage"
			class="mb-2"
		/>
		<v-tag
			v-for="(item, i) in filters"
			:key="i"
			:text="item.text"
			:color="item.color"
			:close="false"
			class="my-2"
		/>
		<v-data-table
			v-bind:class=
				"{
					'mt-4': filters.length == 0,
					'mt-0': filters.length > 0,
				}"
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
						<crud-filter-dialog
							ref="filterDialog"
							:fields="headers"
							:schema="schema"
							:activeFilters="filters"
							@filterApply="filterApply($event)"
						/>
						<v-btn
							v-show="filters.length > 0"
							color="warning"
							class="mr-2"
							@click.stop="resetEvent()"
						>
							Reset
						</v-btn>
						<crud-update-dialog
							ref="updateDialog"
							buttonText="Create"
							:dialogTitle="updateDialogTitle"
							:collection="collection"
							:primaryKey="primaryKey"
							:fields="headers"
							:schema="schema"
							@createClick="createItem()"
							@createSave="createSave()"
							@updateSave="updateSave()"
						/>
						<crud-info-dialog
							ref="infoDialog"
							:dialogTitle="infoDialogTitle"
							:collection="collection"
							:primaryKey="primaryKey"
							:record="currentRecord"
							@deleteSave="deleteSave()"
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
	</div>
</template>

<script lang="coffee">

	import appConfig from '~/appConfig.json'
	import alertToggle from '~/mixins/alertToggle'
	import models from '~/assets/json/models.json'
	import { titleCase, getDateAndTime } from '~/modules/miscUtils'
	import crudUpdateDialog from '~/components/crud/updateDialog'
	import crudInfoDialog from '~/components/crud/infoDialog'
	import crudFilterDialog from '~/components/crud/filterDialog'
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
					if models[model].encryptFields.includes(key) or models[model].encodeFields.includes(key)
						header.show = false
					if models[model].listFields.includes(key)
						header.list = true
						header.listMethod = 'Set'
					if models[model].dateFields.includes(key)
						header.date = true
					headers.push(header)
			for field in extraFields
				headers.push(field)

			return
				model: model
				schema: headerKeys
				collection: models[model].collectionName
				title: titleCase(model)
				primaryKey: models[model].primaryKey
				updateDialogTitle: 'Create an Item'
				infoDialogTitle: 'Item #1'
				headers: headers
				items: []
				itemsUpdate: []
				itemsDisplay: []
				filters: []
				currentRecord: {}
				currentIndex: 1
				itemsPerPage: 10

		mixins: [
			validation
			alertToggle
		]

		components: {
			crudUpdateDialog
			crudInfoDialog
			crudFilterDialog
		}

		created: ->
			await this.loadItems()

		methods:

			# Load Items

			loadItems: (data) ->
				if !data?
					data = await this.$api.getAll(this.collection)
				if data.status == 'ok'
					this.items = cloneDeep(data.response)
					this.itemsUpdate = cloneDeep(data.response)
					for record in data.response
						for key, val of record

							# List Fields

							if models[this.model].listFields.includes(key)
								record[key] = val.join(',')
								this.itemsUpdate[data.response.indexOf(record)][key] = val.join(',')

							# Boolean Fields

							if models[this.model].booleanFields.includes(key)
								record[key] = String(val)
								this.itemsUpdate[data.response.indexOf(record)][key] = String(val)

							# Date Fields

							if [...models[this.model].dateFields, 'createdAt', 'updatedAt'].includes(key)
								dateTime = getDateAndTime(val)
								milDateTime = getDateAndTime(val, true)
								record[key] = "#{dateTime.date} #{dateTime.time}"
								this.itemsUpdate[data.response.indexOf(record)][key] = "#{milDateTime.date} #{milDateTime.time}"

							# Ellipsis

							else if val.length >= 31
								record[key] = "#{val.substring(0, 28)}..."

					this.itemsDisplay = data.response

			# Create Item

			createItem: (item) ->
				for header in this.headers
					header.model = ''

			# View Item

			viewItem: (item) ->
				this.currentIndex = this.itemsDisplay.indexOf(item)
				this.currentRecord = this.items[this.currentIndex]
				this.$refs.infoDialog.dialogTitleText = "Item ##{this.currentIndex + 1}"
				this.$refs.infoDialog.showDelete = false
				this.$refs.infoDialog.showDialog = true

			# Edit Item

			editItem: (item) ->
				this.getItemModels(item)
				this.$refs.updateDialog.dialogTitleText = "Update Item ##{this.currentIndex + 1}"
				this.$refs.updateDialog.mode = 'update'
				this.$refs.updateDialog.primaryValue = this.items[this.currentIndex][this.primaryKey]
				this.$refs.updateDialog.showDialog = true

			# Copy Item

			copyItem: (item) ->
				this.getItemModels(item)
				this.$refs.updateDialog.dialogTitleText = "Copy Item ##{this.currentIndex + 1}"
				this.$refs.updateDialog.mode = 'create'
				this.$refs.updateDialog.showDialog = true

			# Delete Item

			deleteItem: (item) ->
				this.currentIndex = this.itemsDisplay.indexOf(item)
				this.currentRecord = this.items[this.currentIndex]
				this.$refs.infoDialog.dialogTitleText = "Delete Item ##{this.currentIndex + 1}"
				this.$refs.infoDialog.showDelete = true
				this.$refs.infoDialog.showDialog = true

			# Get Item Models

			getItemModels: (item) ->
				this.currentIndex = this.itemsDisplay.indexOf(item)
				for key, val of this.itemsUpdate[this.currentIndex]
					for header in this.headers
						if key == header.value
							header.model = val
						if header.listMethod?
							header.listMethod = 'Set'

			# Create Save

			createSave: () ->
				this.actionSuccess(
					'Item created successfully'
				)

			# Update Save

			updateSave: () ->
				this.actionSuccess(
					"Item ##{this.currentIndex} updated successfully"
				)

			# Delete Save

			deleteSave: () ->
				this.actionSuccess(
					"Item ##{this.currentIndex} deleted successfully"
				)

			# Filter Apply

			filterApply: (filters) ->
				whereArgs = []
				for filter in filters
					whereArgs.push(
						field: filter.field
						op: filter.operator
						value: filter.value
					)
				data = await this.$api.find(
					this.collection,
					where: whereArgs
				)
				this.filters = filters
				this.$refs.filterDialog.filters = cloneDeep(filters)
				this.loadItems(data)
				this.message = "Items filtered successfully"
				this.messageOn()

			# Reset Event

			resetEvent: ->
				this.filters = []
				this.actionSuccess(
					"Filters cleared successfully"
				)

			# Action Success

			actionSuccess: (message) ->
				this.loadItems()
				this.message = message
				this.messageOn()

</script>