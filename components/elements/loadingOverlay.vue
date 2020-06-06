<template>
	<v-overlay :value="isLoading">
		<v-progress-circular
			indeterminate
			color="secondary"
			size="64"
		/>
	</v-overlay>
</template>

<script lang="coffee">

	export default

		props:
			loading: Boolean
				default: true

		data: ->
			return
				isLoading: this.loading

		watch:
			loading: (value) ->
				this.isLoading = value
				this.$emit("update:loading", value)

</script>