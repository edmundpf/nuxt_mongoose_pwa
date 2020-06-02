<template>
	<v-overlay :value="loading">
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

</script>