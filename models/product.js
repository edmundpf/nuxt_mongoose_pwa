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
		sale: {
			type: Boolean,
			required: true,
			default: false,
		},
		date: {
			type: Date,
			required: true,
		}
	},
}