<script lang="coffee">

	import alert from '~/components/elements/alert'

	export default
		data: ->
			message: this.$route.params.message or ''
			showMessage: this.$route.params.message? and this.$route.params.message.length > 0
			messageClass: this.$route.params.messageClass or 'success'

		components: {
			alert
		}

</script>