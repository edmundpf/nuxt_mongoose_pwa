module.exports = {
	name: 'product',
	schema: {
		name: {
			type: String,
			unique: true,
			required: true,
			primaryKey: true,
		},
		price: {
			type: Number,
			required: true,
		},
		onSale: {
			type: Boolean,
			required: true,
			default: false,
		},
		saleStart: {
			type: Date,
			required: true,
		},
		saleEnd: {
			type: Date,
			required: true,
		},
	},
}