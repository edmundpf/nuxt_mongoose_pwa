<template>
	<v-alert
		dense
		class="my-4"
		dismissible
		:type="type"
		v-model="showMessage"
		transition="scale-transition"
	>
		{{ message }}
	</v-alert>
</template>

<script lang="coffee">

	export default
		data: ->
			showMessage: this.show or false
		props:
			message:
				type: String
				default: ''
			type:
				type: String
				default: 'success'
			show:
				type: Boolean
				default: false
		watch:
			show: (value) ->
				this.showMessage = value
			showMessage: (value) ->
				this.$emit('update:show', value)

</script>