<template>
	<v-row justify="center">
		<v-col
			class="text-center"
			lg="6"
			sm="8"
		>
			<h1>{{ title }}</h1>
			<alert
				:message="message"
				type="error"
				v-bind:show.sync="showMessage"
			/>
			<v-form
				ref="form"
				class="my-4"
				:lazy-validation="false"
				v-model="formValid"
			>

				<v-text-field
					v-for="(item, key) in fieldItems"
					v-if="showAuthField(item, key)"
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
		</v-col>
	</v-row>
</template>

<script lang="coffee">

	import alert from '~/mixins/alert'
	import { errorMessage } from '~/modules/apiParse'
	validation = require('mongoose-auto-api.validation')

	export default
		props:
			title:
				type: String
				default: 'Log In'
			isSignup:
				type: Boolean
				default: false
		mixins: [
			alert
		]
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

		methods:

			# Validation Flow

			valFlow: (val) ->
				if val.messages.length > 0
					return val.messages[0]
				else
					return true

			# Validate Email

			emailValidation: (text) ->
				return this.valFlow(
					validation.userVal(
						text,
						'email'
					)
				)

			# Validate Secret Key

			secretKeyValidation: (text) ->
				return this.valFlow(
					validation.passVal(
						text,
						'secret key'
					)
				)

			# Validate Password

			passwordValidation: (text) ->
				return this.valFlow(
					validation.passVal(
						text,
						'password'
					)
				)

			# Validate Password Confirmation

			confirmPasswordValidation: (text) ->
				return this.valFlow(
					validation.confirmPassVal(
						text,
						this.fieldItems.password.model,
						'password confirmation'
					)
				)

			# Show Auth Field

			showAuthField: (item, key) ->
				if !this.isSignup and ['confirmPassword', 'secretKey'].includes(key)
					return false
				else
					return true

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
					this.hasMessage = true
					this.message = errorMessage(res)

</script>