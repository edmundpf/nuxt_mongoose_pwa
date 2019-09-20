<template>
	<authForm
		title="Sign Up"
		:isSignup="true"
	/>
</template>

<script lang="coffee">

	import authForm from '~/components/auth/authForm'

	export default
		components: {
			authForm
		}

</script>