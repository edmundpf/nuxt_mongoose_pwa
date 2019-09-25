<template>
	<v-chip
		label
		close
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

		methods:

			# Close Event

			closeEvent: ->
				this.$emit('close')

</script>