<template>
	<modal
		:hasButton="false"
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

			<rowCol :textCenter="false">
				<strong
					class="white--text"
					v-show="showDelete"
				>
					Are you sure you want to delete the following item?
				</strong>
				<pre class="pre-wrap">{{ recordText }}</pre>
			</rowCol>
		</template>

		<template v-slot:controls>
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
		</template>
	</modal>
</template>

<script lang="coffee">

	import alert from '~/mixins/alert'
	import modal from '~/components/elements/modal'

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
			defaultTitle = 'Item #1'
			return
				showDialog: false
				showDelete: true
				defaultTitle: defaultTitle
				dialogTitleText: this.dialogTitle || defaultTitle

		mixins: [
			alert
		]

		components: {
			modal
		}

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