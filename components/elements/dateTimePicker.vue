<template>
	<v-dialog
		v-model="display"
		:width="dialogWidth"
	>
		<template v-slot:activator="{ on }">
			<v-text-field
				v-bind="textFieldProps"
				:disabled="disabled"
				:label="label"
				:value="formattedDateTime"
				v-on="on"
				readonly
			/>
		</template>
		<v-card>
			<v-card-text class="pa-0">
				<v-tabs
					fixed-tabs
					v-model="activeTab"
				>
					<v-tab
						color="info"
						key="calendar"
					>
						<slot name="dateIcon">
							<v-icon color="info">mdi-calendar</v-icon>
						</slot>
					</v-tab>
					<v-tab
						color="secondary"
						key="timer"
						:disabled="!date"
					>
						<slot name="timeIcon">
							<v-icon color="secondary">mdi-clock-outline</v-icon>
						</slot>
					</v-tab>
					<v-tab-item key="calendar">
						<v-date-picker
							v-model="date"
							v-bind="datePickerProps"
							@input="showTimePicker"
							full-width
						/>
					</v-tab-item>
					<v-tab-item key="timer">
						<v-time-picker
							ref="timer"
							class="v-time-picker-custom"
							v-model="time"
							v-bind="timePickerProps"
							full-width
						/>
					</v-tab-item>
				</v-tabs>
			</v-card-text>
			<v-card-actions>
				<v-spacer></v-spacer>
				<slot name="actions" :parent="this">
					<v-btn
						text
						color="warning"
						@click.native="clearHandler"
					>
						{{ clearText }}
					</v-btn>
					<v-btn
						text
						color="success"
						@click="okHandler"
					>
						{{ okText }}
					</v-btn>
				</slot>
			</v-card-actions>
		</v-card>
	</v-dialog>
</template>

<script lang="coffee">

	#: Modified version of vuetify-datetime-picker (Github: @darrenfang)
	#: https://github.com/darrenfang/vuetify-datetime-picker
	#: NPM - vuetify-datetime-picker

	import { format, parse } from 'date-fns'

	DEFAULT_DATE = ''
	DEFAULT_TIME = '00:00:00'
	DATE_FORMAT = 'yyyy-MM-dd'
	TIME_FORMAT = 'HH:mm:ss'
	DEFAULT_DATE_FORMAT = 'yyyy-MM-dd'
	DEFAULT_TIME_FORMAT = 'HH:mm:ss'

	export default

		name: 'v-datetime-picker'

		model:
			prop: 'datetime'
			event: 'input'

		props:
			datetime:
				type: [Date, String]
				default: null
			disabled:
				type: Boolean
			label:
				type: String
				default: ''
			dialogWidth:
				type: Number
				default: 340
			clearText:
				type: String
				default: 'Clear'
			okText:
				type: String
				default: 'Ok'
			textFieldProps:
				type: Object
			datePickerProps:
				type: Object
			timePickerProps:
				type: Object

		data: ->
			return
				date: DEFAULT_DATE
				time: DEFAULT_TIME
				display: false
				activeTab: 0

		created: ->
			if this.datetime
				dateTime = parse(
					this.datetime,
					this.dateTimeFormat,
					new Date()
				)
				this.date = format(dateTime, DEFAULT_DATE_FORMAT)
				this.time = format(dateTime, DEFAULT_TIME_FORMAT)

		computed:

			# Date Time Format

			dateTimeFormat: ->
				return "#{DATE_FORMAT} #{TIME_FORMAT}"

			# Default Date Time Format

			defaultDateTimeFormat: ->
				return "#{DEFAULT_DATE_FORMAT} #{DEFAULT_TIME_FORMAT}"

			# Formatted Date Time

			formattedDateTime: ->
				return (if this.selectedDateTime then format(this.selectedDateTime, this.dateTimeFormat) else '')

			# Selected Date Time

			selectedDateTime: ->
				if this.date and this.time
					dateTimeString = "#{this.date} #{this.time}"
					if this.time.length == 5
						dateTimeString += ':00'
					return parse(
						dateTimeString,
						this.defaultDateTimeFormat,
						new Date()
					)
				else
					return null

		methods:

			# OK Handler

			okHandler: ->
				this.resetPicker()
				this.$emit('input', this.formattedDateTime)

			# Clear Handler

			clearHandler: ->
				this.resetPicker()
				this.date = DEFAULT_DATE
				this.time = DEFAULT_TIME
				this.$emit('input', null)

			# Reset Picker

			resetPicker: ->
				this.display = false
				this.activeTab = 0
				if this.$refs.timer
					this.$refs.timer.selectingHour = true

			# Show Time Picker

			showTimePicker: ->
				this.activeTab = 1

</script>

<style lang="scss">
	.v-time-picker-custom .v-picker__title {
		height: 84px;
		padding-top: 10px;
	}
</style>