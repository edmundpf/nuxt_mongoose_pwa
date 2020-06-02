<template>
	<v-dialog
		v-model="dialogIsShown"
		:max-width="extraSmallWidth"
		scrollable
	>
		<template v-if="hasButton" v-slot:activator="{ on }">
			<v-btn
				v-on="on"
				:color="buttonColor"
				:class="buttonClass"
				@click.stop="buttonEvent()"
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
					<slot name="body"></slot>
				</v-container>
			</v-card-text>
			<v-card-actions>
				<div class="flex-grow-1"></div>
				<slot name="controls"></slot>
			</v-card-actions>
		</v-card>
	</v-dialog>
</template>

<script lang="coffee">

	import sizes from '~/assets/json/sizes'

	export default

		props:
			hasButton:
				type: Boolean
				default: false
			buttonColor:
				type: String
				default: 'secondary'
			buttonText:
				type: String
				default: ''
			buttonEvent:
				type: Function
				default: null
			buttonClass:
				type: String
				default: null
			dialogTitle:
				type: String
				default: ''
			showDialog:
				type: Boolean
				default: false

		data: ->
			return
				extraSmallWidth: sizes.extraSmall
				dialogTitleText: this.dialogTitle
				dialogIsShown: this.showDialog

		watch:
			dialogTitle: (value) ->
				this.dialogTitleText = value
				this.$emit('update:dialogTitle', value)
			showDialog: (value) ->
				this.dialogIsShown = value
				this.$emit('update:showDialog', value)

</script>