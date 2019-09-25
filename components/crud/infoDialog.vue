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
					<alert
						:message="message"
						type="error"
						v-bind:show.sync="showMessage"
					/>
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

<script lang="coffee">

	import sizes from '~/assets/json/sizes'
	import alert from '~/mixins/alert'

	export default

		name: 'crud-info-dialog'

		props:
			dialogTitle:
				type: String
				default: ''
			record:
				type: Object
				default: {}
			collection:
				type: String
				default: ''
			primaryKey:
				type: String
				default: ''

		data: ->
			defaultTitle = 'Record #1'
			return
				showDialog: false
				showDelete: true
				defaultTitle: defaultTitle
				dialogTitleText: this.dialogTitle || defaultTitle
				extraSmallWidth: sizes.extraSmall

		mixins: [
			alert
		]

		computed:
			recordText: () ->
				return JSON.stringify(this.record, null, 2)

		methods:

			# Message and Dialog Reset

			messageAndDialogReset: ->
					this.showDialog = false
					this.showMessage = false
					this.message = ''

			# Delete Event

			deleteEvent: () ->
				updateDict = [this.primaryKey]: this.record[this.primaryKey]
				res = await this.$api.remove(
					this.collection,
					updateDict
				)
				if res.status == 'ok'
					this.$emit('deleteSave')
					this.messageAndDialogReset()
				else
					this.showMessage = true
					this.message = errorMessage(res)

			# Close Event

			closeEvent: () ->
				this.messageAndDialogReset()

</script>