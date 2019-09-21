<template>
	<v-row justify="center">
		<v-col class="text-center">
			<alert
				:message="message"
				:type="messageClass"
				v-bind:show.sync="showMessage"
			/>
		</v-col>
	</v-row>
</template>

<script lang="coffee">

	import alertToggle from '~/mixins/alertToggle'

	export default
		mixins: [
			alertToggle
		]

</script>

