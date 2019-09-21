<script lang="coffee">

	import alert from '~/mixins/alert'

	export default
		mixins: [
			alert
		]

		created: ->
			if this.showMessage
				this.messageTimeout()

		methods:
			messageOn: ->
				if !this.showMessage
					this.showMessage = true
					this.messageTimeout()
			messageOff: ->
				if this.showMessage
					this.showMessage = false
			messageTimeout: ->
				setTimeout(this.messageOff, 3000)

</script>