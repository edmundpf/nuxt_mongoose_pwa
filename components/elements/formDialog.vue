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
					<rowCol>
						<v-form
							ref="form"
							:lazy-validation="false"
							v-model="formValid"
							@keyup.native.enter="saveEvent()"
						>
							<v-text-field
								v-for="(item, key) in fields"
								v-if="!isHiddenField(item)"
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
								outlined
							/>
						</v-form>
					</rowCol>
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
				formValid: true
				showDialog: false
				defaultTitle: defaultTitle
				dialogTitleText: this.dialogTitle || defaultTitle
				extraSmallWidth: sizes.extraSmall

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
					this.$refs.form.reset()
				catch error
				this.$emit('createClick')


</script>