module.exports = {
	name: 'sale',
	schema: {
		product: {
			type: String,
			required: true,
		},
		price: {
			type: Number,
			required: true,
		},
	},
}