<template>
	<v-skeleton-loader
		:loading="isLoading"
		:type="skeletonType"
		class="mx-auto"
	>
		<v-list :color="transparent ? backgroundColor : null">
			<template v-for="(item, i) in items">
				<v-list-item
					:key="i"
					@click.stop="item.action != null ? item.action(item) : null"
					:to="item.to != null ? item.to : null"
				>
					<v-list-item-content>
						<v-list-item-title v-html="item.title" />
						<v-list-item-subtitle
							v-if="item.subtitle != null"
							v-html="item.subtitle"
						/>
					</v-list-item-content>
				</v-list-item>
				<v-divider :key="`div-${i}`" v-if="divided" />
			</template>
		</v-list>
	</v-skeleton-loader>
</template>

<script lang="coffee">

	import colors from '~/assets/json/colors.json'

	export default

		props:
			items:
				type: Array
				default: []
			divided:
				type: Boolean
				default: true
			transparent:
				type: Boolean
				default: false
			action:
				type: Function
				default: null
			to:
				type: String
				default: null
			skeletonItems:
				type: Number
				default: 3
			loading:
				type: Boolean
				default: false

		data: ->
			return
				isLoading: this.loading
				backgroundColor: colors.background
				skeletonType: "list-item-two-line@#{this.skeletonItems}"

		watch:
			loading: (value) ->
				this.isLoading = value
				this.$emit("update:loading", value)

</script>