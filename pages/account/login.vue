<template>
	<authForm
		title="Log In"
		:isSignup="false"
	/>
</template>

<script lang="coffee">

	import authForm from '~/components/auth/authForm'

	export default

		components: {
			authForm
		}

</script>