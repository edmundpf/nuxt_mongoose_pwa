const fs = require('fs')
const api = require('mongoose-auto-api.rest')
const cloneDeep = require('lodash.clonedeep')

// Write Models Info JSON file

models = cloneDeep(api.models)

for (const model in models) {
	models[model].booleanFields = []
	models[model].dateFields = []
	for (const path in models[model].model.schema.paths) {
		if (models[model].model.schema.paths[path].instance == 'Boolean') {
			models[model].booleanFields.push(path)
		}
		else if (models[model].model.schema.paths[path].instance == 'Date') {
			if (!['updatedAt', 'createdAt'].includes(path)) {
				models[model].dateFields.push(path)
			}
		}
		if (models[model].primaryKey == '_id') {
			models[model].schema._id = {
				unique: true,
				required: true,
			}
		}
	}
	delete models[model].model
}

const filename = './assets/json/models.json'
const json = JSON.stringify(
	models,
	null,
	2
)

fs.writeFileSync(
	filename,
	json,
)

console.log(`Models Info data stored in ${filename}`)

//::: End Program ::://