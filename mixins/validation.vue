<script lang="coffee">

	validation = require('mongoose-auto-api.validation')

	export default
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

			# Required Validation

			requiredValidation: (field) ->
				val = (text) ->
					return this.valFlow(
						validation.requiredVal(
							text,
							field
						)
					)
				return val.bind(this)

			# JSON Validation

			jsonValidation: (field) ->
				val = (text) ->
					return this.valFlow(
						validation.jsonVal(
							text,
							field
						)
					)
				return val.bind(this)

</script>