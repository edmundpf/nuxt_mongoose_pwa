<template>
	<v-dialog
		v-model="showDialog"
		:max-width="extraSmallWidth"
		persistent
	>
		<template v-slot:activator="{ on }">
			<v-btn
				color="secondary"
				v-on="on"
				@click.stop="createEvent()"
			>
				{{ buttonText }}
			</v-btn>
		</template>
		<v-card>
			<v-card-title>
				<span class="headline">{{ dialogTitleText }}</span>
			</v-card-title>
			<v-card-text>
				<v-container>
						<v-form
							ref="form"
							:key="formKey"
							:lazy-validation="false"
							v-model="formValid"
							@keyup.native.enter="saveEvent()"
						>
							<template
								v-for="(item, key) in fields"
								v-if="!isHiddenField(item)"
							>
								<v-row justify="center">
									<v-col
										class="pa-0"
										:cols="item.list ? 7 : 12"
										:sm="item.list ? 9 : 12"
									>
										<v-text-field
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
									</v-col>
									<v-col
										class="pa-0"
										v-if="item.list"
									>
										<v-select
											:key="key"
											:items="listMethods"
											:value="item.listMethod"
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
				</v-container>
			</v-card-text>
			<v-card-actions>
				<div class="flex-grow-1"></div>
				<v-btn
					class="mb-2"
					color="success"
					@click="saveEvent()"
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
			</v-card-actions>

		</v-card>
	</v-dialog>
</template>


</template>

<script lang="coffee">

	import sizes from '~/assets/json/sizes'

	export default

		data: ->
			defaultTitle = 'Create a Record'
			return
				formKey: 0
				formValid: true
				showDialog: false
				defaultTitle: defaultTitle
				dialogTitleText: this.dialogTitle || defaultTitle
				extraSmallWidth: sizes.extraSmall
				listMethods: [
					'Set'
					'Push'
					'Unique'
				]

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

			# Hidden Field

			isHiddenField: (item) ->
				hiddenFields = [
					'action'
					'createdAt'
					'updatedAt'
				]
				return hiddenFields.includes(item.value)

			# Save Event

			saveEvent: () ->
				this.showDialog = false

			# Close Event

			closeEvent: () ->
				this.showDialog = false

			# Create Event

			createEvent: () ->
				this.dialogTitleText = this.defaultTitle
				try
					this.formKey += 1
				catch error
				this.$emit('createClick')


</script>