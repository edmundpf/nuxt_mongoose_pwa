<template>
	<div>
		<v-row
			class="justify-center"
			v-for="(row, i) in items"
			:key="i"
		>
			<v-col
				v-for="(col, x) in row"
				:key="x"
				sm="4"
				lg="3"
				xl="2"
			>
				<v-card>
					<v-card-title><h4>{{ col.title }}</h4></v-card-title>
					<v-divider></v-divider>
					<v-card-text v-bind:class="{ [col.color]: col.color != null }">
						<h3 class="white--text">{{ col.subtitle }}</h3>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>
	</div>
</template>

<script lang="coffee">

	export default

		props:
			items:
				type: Array
				default: []

</script>