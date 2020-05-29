<template>
	<rowCol
		:textCenter="false"
		:condense="true"
	>
		<list
			:items="dataModels"
		/>
	</rowCol>
</template>

<script lang="coffee">

	import list from '~/components/elements/list'
	import { titleCase } from '~/modules/miscUtils'
	import models from '~/assets/json/models.json'

	export default

		data: ->
			dataModels = []
			for key, val of models
				dataModels.push(
					title: titleCase(val.collectionName)
					subtitle: "Collection: #{val.collectionName}"
					action: this.crudNav
					model: key
				)
			return
				dataModels: dataModels

		components: {
			list
		}

		methods:

			crudNav: (item) ->
				this.$router.push(
					name: 'data-crud'
					query:
						model: item.model
				)

</script>