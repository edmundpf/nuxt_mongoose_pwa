<template>
	<rowCol :condense="true">

		<h1>{{ title }}</h1>
		<alert
			class="my-2"
			:message="message"
			type="error"
			v-bind:show.sync="showMessage"
		/>
		<v-form
			ref="form"
			class="my-4"
			:lazy-validation="false"
			v-model="formValid"
			@keyup.native.enter="submitEvent()"
		>

			<v-text-field
				v-for="(item, key) in visibleAuthFields"
				:key="key"
				:label="item.label"
				:type="getFieldType(item)"
				:append-icon="getFieldIcon(item)"
				@click:append="getIconClickEvent(item)"
				color="info"
				outlined
				v-model="item.model"
				:rules="item.rules"
				required
			/>

			<v-checkbox
				v-model="rememberMe"
				label="Remember Me"
			></v-checkbox>

			<v-btn
				x-large
				block
				v-bind:class="{ success: message.length == 0, error: message.length > 0 }"
				:disabled="!formValid"
				@click.stop="submitEvent()"
			>
				Submit
			</v-btn>

		</v-form>
	</rowCol>
</template>

<script lang="coffee">

	import alert from '~/mixins/alert'
	import { errorMessage } from '~/modules/apiParse'
	import validation from '~/mixins/validation'

	hiddenFields = ['confirmPassword', 'secretKey']

	export default

		props:
			title:
				type: String
				default: 'Log In'
			isSignup:
				type: Boolean
				default: false

		data: ->
			return
				formValid: true
				rememberMe: false
				fieldItems:
					email:
						label: 'Email'
						model: ''
						rules: [ this.emailValidation ]
					secretKey:
						label: 'Secret Key'
						model: ''
						rules: [ this.secretKeyValidation ]
						show: false
					password:
						label: 'Password'
						model: ''
						rules: [ this.passwordValidation ]
						show: false
					confirmPassword:
						label: 'Confirm Password'
						model: ''
						rules: [ this.confirmPasswordValidation ]
						show: false

		mixins: [
			alert
			validation
		]

		computed:

			visibleAuthFields: ->
				fieldsTemp = {}
				for key, val of this.fieldItems
					if this.isSignup or !hiddenFields.includes(key)
						fieldsTemp[key] = val
				return fieldsTemp

		methods:

			# Get Field Icon

			getFieldIcon: (item) ->
				if item.show?
					return (if item.show then 'mdi-eye' else 'mdi-eye-off')
				else
					return null

			# Get Field Type

			getFieldType: (item) ->
				if item.show?
					return (if item.show then 'text' else 'password')
				else
					return null

			# Get Icon Click Event

			getIconClickEvent: (item) ->
				if item.show?
					return (item.show = !item.show)
				else
					return null

			# Submit Event

			submitEvent: ->
				if !this.isSignup
					res = await this.$api.login(
						username: this.fieldItems.email.model
						password: this.fieldItems.password.model
					)
				else
					res = await this.$api.signup(
						username: this.fieldItems.email.model
						password: this.fieldItems.password.model
						secret_key: this.fieldItems.secretKey.model
					)
				if res.status == 'ok' and res.response.access_token?
					this.$store.dispatch(
						'auth/setState',
						loggedIn: true
						remember: this.rememberMe
						username: res.response.username
						accessToken: res.response.access_token
					)
					this.$store.dispatch(
						'nav/setState',
						showLogin: false
						showSignup: false
						showSignout: true
					)
					if !this.isSignup
						message = 'Logged in successfully'
					else
						message = 'Signed up successfully'
					this.$router.push(
						name: 'index'
						params:
							message: message
							messageClass: 'success'
					)
				else
					this.showMessage = true
					this.message = errorMessage(res)

</script>