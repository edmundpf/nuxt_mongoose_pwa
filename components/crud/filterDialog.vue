<template>
	<modal
		:hasButton="true"
		buttonColor="accent"
		buttonClass="mr-2"
		buttonText="Filter"
		:buttonEvent="filterEvent"
		v-bind:dialogTitle.sync="dialogTitleText"
		v-bind:showDialog.sync="showDialog"
	>
		<template v-slot:body>
			<rowCol :textCenter="false" colClass="pa-0">
				<alert
					:message="message"
					:type="messageClass"
					v-bind:show.sync="showMessage"
				/>
			</rowCol>

			<v-form
				ref="form"
				:key="formKey"
				:lazy-validation="false"
				v-model="formValid"
				v-on:submit.prevent
				@keyup.native.enter="addFilter()"
			>
				<v-row justify="center">
					<v-col
						class="pa-0"
						:cols="6"
					>
						<v-select
							key="field-select"
							:items="fieldItems"
							item-text="text"
							item-value="value"
							v-model="currentField"
							color="secondary"
							item-color="accent"
							return-object
							outlined
						/>
					</v-col>
					<v-col
						class="pa-0"
						:cols="6"
					>
						<v-select
							key="operator-select"
							:items="operatorItems"
							item-text="text"
							item-value="value"
							:hint="currentOperator.hint"
							v-model="currentOperator"
							color="accent"
							item-color="accent"
							return-object
							outlined
						/>
					</v-col>
				</v-row>

				<v-row justify="center">
					<v-col class="pa-0">
						<v-text-field
							v-if="!currentField.date"
							key="value-text-field"
							label="Value"
							prepend-inner-icon="mdi-alert-decagram"
							:rules="rules"
							v-model="currentValue"
							required
							color="info"
							class="mr-0"
							outlined
						/>
						<v-datetime-picker
							v-else
							key="value-datetime-field"
							label="Value"
							v-model="currentValue"
							:text-field-props="{
								appendIcon: 'mdi-calendar-clock',
								prependInnerIcon: 'mdi-alert-decagram',
								rules: rules,
								color: 'info',
								outlined: '',
								required: '',
							}"
							:time-picker-props="{ ampmInTitle: true }"
						/>
					</v-col>
				</v-row>

				<rowCol :textCenter="false" colClass="pa-0">
					<v-tag
						v-for="(item, i) in filters"
						:key="i"
						:text="item.text"
						:color="item.color"
						@close="removeFilter(i)"
					/>
				</rowCol>

			</v-form>
		</template>

		<template v-slot:controls>
			<v-btn
				class="mb-2"
				color="success"
				@click="applyEvent()"
			>
				Apply
			</v-btn>
			<v-btn
				class="mb-2"
				color="secondary"
				@click="addFilter()"
				:disabled="!formValid"
			>
				Add Filter
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

	import alertToggle from '~/mixins/alertToggle'
	import modal from '~/components/elements/modal'
	import { errorMessage } from '~/modules/apiParse'
	import validation from '~/mixins/validation'
	import operators from '~/assets/json/operators'
	cloneDeep = require('lodash.clonedeep')

	export default

		name: 'crud-filter-dialog'

		props:
			fields:
				type: Array
				default: []
			schema:
				type: Array
				default: []
			activeFilters:
				type: Array
				default: []

		data: ->

			fieldItems = cloneDeep(this.fields)
			for index of fieldItems
				if ['createdAt', 'updatedAt'].includes(fieldItems[index].value)
					fieldItems[index].date = true
				if fieldItems[index].value == 'action'
					fieldItems.splice(index, 1)

			return
				dialogTitleText: 'Filter Items'
				formValid: true
				showDialog: false
				formKey: 0
				currentColor: 0
				currentValue: ''
				currentField: fieldItems[0]
				currentOperator: operators[0]
				fieldItems: fieldItems
				operatorItems: operators
				filters: []
				rules: [ this.requiredValidation('value') ]
				colors: [
					'info'
					'success'
					'warning'
					'accent'
					'secondary'
					'error'
					'primary'
				]

		mixins: [
			alertToggle
			validation
		]

		components: {
			modal
		}

		methods:

			# Message and Dialog Reset

			messageAndDialogReset: ->
					this.showDialog = false
					this.showMessage = false
					this.message = ''

			# Show Alert

			showAlert: (message, messageClass='success') ->
				this.messageClass = messageClass
				this.message = message
				this.messageOn()

			# Reset Form

			resetForm: ->
				this.formKey += 1
				this.currentValue = ''
				this.currentField = this.fieldItems[0]
				this.currentOperator = this.operatorItems[0]

			# Filter Event

			filterEvent: () ->
				if this.activeFilters.length == 0
					this.filters = []
				this.resetForm()
				this.showDialog = true

			# Add Filter

			addFilter: () ->
				if this.formValid
					curFilter =
						color: this.colors[this.currentColor % 7]
						field: this.currentField.value
						operator: this.currentOperator.value
						value: this.currentValue
						text: "#{this.currentField.value} | #{this.currentOperator.value} | #{this.currentValue}"
					this.currentColor = (this.currentColor + 1) % 7
					this.filters.push(curFilter)
					this.resetForm()
					this.showAlert(
						"Added filter: #{curFilter.text}",
						'success'
					)

			# Remove Filter

			removeFilter: (index) ->
				curFilterText = this.filters[index].text
				this.filters.splice(index, 1)
				this.showAlert(
					"Removed filter: #{curFilterText}",
					'warning'
				)

			# Apply Event

			applyEvent: () ->
				this.$emit('filterApply', this.filters)
				this.messageAndDialogReset()

			# Close Event

			closeEvent: () ->
				this.messageAndDialogReset()

</script>