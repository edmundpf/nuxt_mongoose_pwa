<template>
	<v-row justify="center">
		<v-col class="text-center">
			<v-alert
				dense
				dismissible
				class="my-4"
				:type="messageClass"
				v-model="hasMessage"
			>
				{{ message }}
			</v-alert>
			You are authenticated.
		</v-col>
	</v-row>
</template>

<script lang="coffee">

	export default
		data: ->
			message: this.$route.params.message or ''
			hasMessage: this.$route.params.message.length > 0
			messageClass: this.$route.params.messageClass or 'success'
		created: ->
			setTimeout(this.toggleMessage, 3000)
		methods:

			# Toggle Message

			toggleMessage: ->
				this.hasMessage = !this.hasMessage
				if this.hasMessage
					setTimeout(this.toggleMessage, 3000)

</script>

