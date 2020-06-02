<template>
	<v-row
		:class="rowClass ? rowClass : null"
		:justify="center ? 'center' : null"
	>
		<v-col
			:class="columnClass"
			:sm="condense ? 8 : null"
			:lg="condense ? 6 : null"
			:xl="condense ? 4 : null"
		>
			<slot />
		</v-col>
	</v-row>
</template>

<script lang="coffee">

	export default

		props:
			center:
				type: Boolean
				default: true
			textCenter:
				type: Boolean
				default: true
			condense:
				type: Boolean
				default: false
			rowClass:
				type: String
				default: null
			colClass:
				type: String
				default: null

		computed:

			# Column Class

			columnClass: ->
				classes = []
				if this.textCenter
					classes.push('text-center')
				if this.colClass
					classes.push(this.colClass)
				classText = classes.join(' ')
				return if classText then classText else null

</script>