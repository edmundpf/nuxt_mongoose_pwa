<template>
	<v-dialog
		v-model="showDialog"
		:max-width="extraSmallWidth"
		persistent
	>
		<template v-slot:activator="{ on }">
			<v-btn
				color="secondary"
				v-on="on"
			>
				{{ buttonText }}
			</v-btn>
		</template>
		<v-card>
			<v-card-title>
				<span class="headline">{{ dialogTitle }}</span>
			</v-card-title>
			<v-card-text>
				<v-container>
					<rowCol>
						<v-form
							ref="form"
							:lazy-validation="false"
							v-model="formValid"
							@keyup.native.enter="submitEvent()"
						>
							<v-text-field
								v-for="(item, key) in headers"
								:key="key"
								:label="item.text"
								:type="getFieldType(item)"
								:append-icon="getFieldIcon(item)"
								@click:append="getIconClickEvent(item)"
								:required="item.required != null && item.required ? true : false"
								v-model="item.model"
								color="info"
								outlined
							/>
						</v-form>
					</rowCol>
				</v-container>
			</v-card-text>
			<v-card-actions>
				<div class="flex-grow-1"></div>
				<v-btn @click="showDialog = false">Save</v-btn>
				<v-btn @click="showDialog = false">Close</v-btn>
			</v-card-actions>
		</v-card>
	</v-dialog>
</template>


</template>

<script lang="coffee">

	import sizes from '~/assets/json/sizes'

	export default
		data: ->
			formValid: true
			showDialog: false
			extraSmallWidth: sizes.extraSmall

		props:
			buttonText:
				type: String
				default: ''
			dialogTitle:
				type: String
				default: ''
			headers:
				type: Array
				default: []

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

</script>