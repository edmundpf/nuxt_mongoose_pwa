<template>
	<v-dialog
		v-model="showDialog"
		:max-width="extraSmallWidth"
		persistent
	>
		<v-card>
			<v-card-title>
				<span class="headline">{{ dialogTitleText }}</span>
			</v-card-title>
			<v-card-text>
				<v-container>
					<rowCol :textCenter="false">
						<strong
							class="white--text"
							v-show="showDelete"
						>
							Are you sure you want to delete the following record?
						</strong>
						<pre class="pre-wrap">{{ recordText }}</pre>
					</rowCol>
				</v-container>
			</v-card-text>
			<v-card-actions>
				<div class="flex-grow-1"></div>
				<v-btn
					class="mb-2"
					color="error"
					v-show="showDelete"
					@click="deleteEvent()"
				>
					Delete
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
			defaultTitle = 'Record #1'
			return
				showDialog: false
				showDelete: true
				defaultTitle: defaultTitle
				dialogTitleText: this.dialogTitle || defaultTitle
				extraSmallWidth: sizes.extraSmall


		computed:
			recordText: () ->
				return JSON.stringify(this.record, null, 2)

		props:
			dialogTitle:
				type: String
				default: ''
			record:
				type: Object
				default: {}

		methods:

			# Hidden Field

			isHiddenField: (item) ->
				hiddenFields = [
					'action'
					'createdAt'
					'updatedAt'
				]
				return hiddenFields.includes(item.value)

			# Delete Event

			deleteEvent: () ->
				this.showDialog = false

			# Close Event

			closeEvent: () ->
				this.showDialog = false

</script>