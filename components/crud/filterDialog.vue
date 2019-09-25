<template>
	<v-dialog
		v-model="showDialog"
		:max-width="extraSmallWidth"
		persistent
	>
		<template v-slot:activator="{ on }">
			<v-btn
				color="accent"
				v-on="on"
				class="mr-2"
				@click.stop="filterEvent()"
			>
				Filter Items
			</v-btn>
		</template>
		<v-card>
			<v-card-title>
				<span class="headline">{{ dialogTitleText }}</span>
			</v-card-title>
			<v-card-text>
				<v-container>
					<alert
						:message="message"
						:type="messageClass"
						v-bind:show.sync="showMessage"
					/>
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
							<v-col
								class="pa-0"
							>
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
										prependInnerIcon: 'mdi-alert-decagram',
										rules: requiredRules,
										color: 'info',
										outlined: '',
										required: '',
									}"
									:time-picker-props="{ ampmInTitle: true }"
								/>
							</v-col>
						</v-row>

						<rowCol>
							<v-tag
								v-for="(item, i) in filters"
								:key="i"
								:text="item.text"
								@close="removeFilter(i)"
							/>
						</rowCol>

					</v-form>
				</v-container>
			</v-card-text>
			<v-card-actions>
				<div class="flex-grow-1"></div>
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
			</v-card-actions>
		</v-card>
	</v-dialog>
</template>

<script lang="coffee">

	import sizes from '~/assets/json/sizes'
	import alertToggle from '~/mixins/alertToggle'
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

		data: ->

			fieldItems = cloneDeep(this.fields)
			for index of fieldItems
				if fieldItems[index].value == 'action'
					fieldItems.splice(index, 1)
			return
				dialogTitleText: 'Filter Records'
				extraSmallWidth: sizes.extraSmall
				formValid: true
				showDialog: false
				formKey: 0
				currentValue: ''
				currentField: fieldItems[0]
				currentOperator: operators[0]
				filters: []
				fieldItems: fieldItems
				operatorItems: operators
				rules: [ this.requiredValidation('value') ]

		mixins: [
			alertToggle
			validation
		]

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
				this.filters = []
				this.resetForm()

			# Add Filter

			addFilter: () ->
				if this.formValid
					curFilter =
						field: this.currentField.value
						operator: this.currentOperator.value
						text: "#{this.currentField.value} #{this.currentOperator.value} #{this.currentValue}"
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