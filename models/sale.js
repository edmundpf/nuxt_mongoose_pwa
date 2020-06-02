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
		code: {
			type: String,
			required: true,
			encode: true,
		}
	},
}