<template>
	<v-chip
		label
		:close="close ? '' : null"
		outlined
		class="mr-2 mb-4"
		:color="color"
		text-color="white"
		@click:close="closeEvent()"
	>
		{{ text }}
	</v-chip>
</template>

<script lang="coffee">

	export default

		name: 'v-tag'

		props:
			text:
				type: String
				default: ''
			color:
				type: String
				default: 'success'
			close:
				type: Boolean
				default: true

		methods:

			# Close Event

			closeEvent: ->
				this.$emit('close')

</script>