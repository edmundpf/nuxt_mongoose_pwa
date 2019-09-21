const fs = require('fs')
const api = require('mongoose-auto-api.rest')
const cloneDeep = require('lodash.clonedeep')

// Write Models Info JSON file

models = cloneDeep(api.models)

for (const model in models) {
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