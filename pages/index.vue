<template>
	<rowCol>
		<alert
			:message="message"
			:type="messageClass"
			v-bind:show.sync="showMessage"
		/>
	</rowCol>
</template>

<script lang="coffee">

	import alertToggle from '~/mixins/alertToggle'

	export default
		mixins: [
			alertToggle
		]

</script>

