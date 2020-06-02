<template>
	<modal
		:hasButton="true"
		buttonColor="secondary"
		:buttonText="buttonText"
		:buttonEvent="createEvent"
		v-bind:dialogTitle.sync="dialogTitleText"
		v-bind:showDialog.sync="showDialog"
	>
		<template v-slot:body>
			<rowCol :textCenter="false" colClass="pa-0">
				<alert
					:message="message"
					type="error"
					v-bind:show.sync="showMessage"
				/>
			</rowCol>

			<v-form
				ref="form"
				:key="formKey"
				:lazy-validation="false"
				v-model="formValid"
				v-on:submit.prevent
				@keyup.native.enter="saveEvent()"
			>
				<template
					v-for="(item, key) in nonHiddenFields"
				>
					<v-row :key="key" justify="center">
						<v-col
							class="pa-0"
							:cols="mode != 'create' && item.list ? 7 : 12"
							:sm="mode != 'create' && item.list ? 9 : 12"
						>
							<v-text-field
								v-if="!item.date"
								:key="key"
								:label="item.text"
								:type="getFieldType(item)"
								:append-icon="getFieldIcon(item)"
								:prepend-inner-icon="getRequiredIcon(item)"
								@click:append="getIconClickEvent(item)"
								:required="item.required != null && item.required ? '' : null"
								:rules="item.rules"
								v-model="item.model"
								color="info"
								class="mr-0"
								outlined
							/>
							<v-datetime-picker
								v-else
								:key="key"
								:label="item.text"
								v-model="item.model"
								:text-field-props="{
									appendIcon: 'mdi-calendar-clock',
									prependInnerIcon: getRequiredIcon(item),
									required: item.required != null && item.required ? '' : null,
									rules: item.rules,
									color: 'info',
									outlined: '',
								}"
								:time-picker-props="{ ampmInTitle: true }"
							/>
						</v-col>
						<v-col
							class="pa-0"
							v-if="mode != 'create' && item.list"
						>
							<v-select
								:key="key"
								:items="Object.keys(listMethods)"
								v-model="item.listMethod"
								color="info"
								item-color="accent"
								outlined
							/>
						</v-col>
					</v-row>
				</template>
			</v-form>
			<span>
				<v-icon
					small
					color="accent"
				>
					mdi-alert-decagram
				</v-icon>
				<small>Required field</small>
			</span>
		</template>

		<template v-slot:controls>
			<v-btn
				class="mb-2"
				color="success"
				@click="saveEvent()"
				:disabled="!formValid"
			>
				Save
			</v-btn>
			<v-btn
				class="mr-2 mb-2"
				color="warning"
				@click="closeEvent()"
			>
				Close
			</v-btn>
		</template>
	</modal>
</template>

<script lang="coffee">

	import alert from '~/mixins/alert'
	import modal from '~/components/elements/modal'
	import { errorMessage } from '~/modules/apiParse'

	hiddenFields = [
		'action'
		'createdAt'
		'updatedAt'
	]

	export default

		name: 'crud-update-dialog'

		props:
			buttonText:
				type: String
				default: ''
			dialogTitle:
				type: String
				default: ''
			fields:
				type: Array
				default: []
			collection:
				type: String
				default: ''
			primaryKey:
				type: String
				default: ''
			schema:
				type: Array
				default: []

		data: ->
			defaultTitle = 'Create an Item'
			return
				defaultTitle: defaultTitle
				dialogTitleText: this.dialogTitle || defaultTitle
				showDialog: false
				formValid: true
				mode: 'create'
				formKey: 0
				primaryValue: ''
				listMethods:
					Set: this.$api.updateSet
					Push: this.$api.updatePush
					Unique: this.$api.updatePushUnique

		mixins: [
			alert
		]

		components: {
			modal
		}

		computed:

			# Non-Hidden Fields Array

			nonHiddenFields: ->
				fieldsTemp = []
				for field in this.fields
					if not hiddenFields.includes(field.value)
						fieldsTemp.push(field)
				return fieldsTemp

		methods:

			# Get Field Icon

			getFieldIcon: (item) ->
				if item.show?
					return (if item.show then 'mdi-eye' else 'mdi-eye-off')
				else
					return null

			# Get Required Icon

			getRequiredIcon: (item) ->
				if item.required != null && item.required
					return 'mdi-alert-decagram'
				else
					return null

			# Get Field Type

			getFieldType: (item) ->
				if item.show?
					return (if item.show then 'text' else 'password')
				else
					return null

			# Get Icon Click Event

			getIconClickEvent: (item) ->
				if item.show?
					return (item.show = !item.show)
				else
					return null

			# Message and Dialog Reset

			messageAndDialogReset: ->
					this.showDialog = false
					this.showMessage = false
					this.message = ''

			# Save Event

			saveEvent: () ->
				if this.formValid
					if this.mode == 'create'
						await this.createSave()
					else if this.mode == 'update'
						await this.updateSave()

			# Close Event

			closeEvent: () ->
				this.messageAndDialogReset()

			# Create Event

			createEvent: () ->
				this.dialogTitleText = this.defaultTitle
				this.mode = 'create'
				try
					this.formKey += 1
				catch error
				this.$emit('createClick')
				this.showDialog = true

			# Create Save

			createSave: () ->
				updateDict = {}
				for field in this.fields
					if this.schema.includes(field.value)
						updateDict[field.value] = field.model

				res = await this.$api.insert(
					this.collection,
					updateDict
				)
				if res.status == 'ok'
					this.$emit('createSave')
					this.messageAndDialogReset()
				else
					this.showMessage = true
					this.message = errorMessage(res)

			# Update Save

			updateSave: () ->
				updateDict = [this.primaryKey]: this.primaryValue
				listUpdates = {}
				for field in this.fields
					if this.schema.includes(field.value)
						if field.value == this.primaryKey
							updateDict.update_primary = field.model
						else
							if !field.list? or !field.list
								updateDict[field.value] = field.model
							else
								if field.model.trim() == ''
									updateVal = []
								else
									updateVal = field.model.split(',')
								listUpdates[field.value] =
									value: updateVal
									method: field.listMethod

				res = await this.$api.update(
					this.collection,
					updateDict
				)

				errors = []
				hasErrors = false
				for key, val of listUpdates
					listRes = await this.listMethods[val.method].bind(this)(
						this.collection,
						[this.primaryKey]: updateDict.update_primary
						[key]: val.value
					)
					if listRes.status != 'ok'
						hasErrors = true
						if listRes.response.messages?
							errors = [
								...errors,
								...listRes.response.messages
							]
						else if listRes.response.message?
							errors.push(listRes.response.message)

				if res.status == 'ok' && !hasErrors
					this.$emit('updateSave')
					this.messageAndDialogReset()
				else
					if res.response.message?
						res.response.messages = [
							res.response.message,
							...errors
						]
						delete res.response.message
					else if res.response.messages?
						res.response.messages = [
							...res.response.messages,
							...errors,
						]
					this.showMessage = true
					this.message = errorMessage(res)

</script>