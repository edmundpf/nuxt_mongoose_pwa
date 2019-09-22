<template>
	<rowCol>

			<h1 v-if="hasNotFoundError">
				{{ notFoundError }}
			</h1>
			<h1 v-else>
				{{ otherError }}
			</h1>

			<v-btn
				x-large
				class="error my-4"
				@click.stop="$router.back()"
			>
				Go Back
			</v-btn>

	</rowCol>
</template>

<script lang="coffee">

	export default
		data: ->
			return
				notFoundError: '404: Not Found'
				otherError: "#{this.error.statusCode}: #{this.error.message}"
		head: ->
			return
				title: if this.hasNotFoundError then this.notFoundError else "#{this.error.statusCode}: Error"
		computed:

			# Check for 404 not found error

			hasNotFoundError: ->
				return this.error.statusCode == 404

		layout: 'empty'
		props:
			error:
				type: Object
				default: null

</script>