<template>
	<v-app dark>
		<topNavbar />
		<v-content>
			<v-container>
				<nuxt />
			</v-container>
		</v-content>
	</v-app>
</template>

<script lang="coffee">

	import topNavbar from '~/components/nav/topNavbar'

	export default

		components: {
			topNavbar
		}

</script>