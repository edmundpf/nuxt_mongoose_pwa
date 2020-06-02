# nuxt-mongoose-pwa

> Nuxt starter PWA integrated with mongoose-auto-api ☕ Automatically create a fully functioning CRUD web app and backend Rest API by simply defining your Mongoose models.

## Install

``` bash
# clone this repository
$ git clone git@github.com:edmundpf/nuxt_mongoose_pwa.git
```

## Build Setup

``` bash
# install dependencies
$ npm install

# serve with hot reload
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```
For detailed explanation on how things work, check out [Nuxt.js docs](https://nuxtjs.org).

## App/Rest API Configuration

``` bash
# start setup cli
$ npm run setup
```
* [Setup CLI Module - mongoose-auto-api.cli](https://github.com/edmundpf/mongoose-auto-api-cli/blob/master/README.md)

![PWA - Setup](https://i.imgur.com/8Fo09lk.gif "PWA - Setup")

## Model Setup
* Add your models by adding your Mongoose models in the */models* directory in the root of your project
	* The API is designed for use with Strings, Numbers, Arrays, Dates, and Booleans.
	* This is intentional for a more relational approach to the database in which models can be joined together using MongoDB's *$lookup* functionality instead of opting for nested objects within documents. This feature is built in to the API.
* [Model Setup - mongoose-auto-api.info](https://github.com/edmundpf/mongoose-auto-api-info/blob/master/README.md#model-setup)

## Run API Standalone

``` bash
# start rest api
$ npm run api
```
* [Rest API Module - mongoose-auto-api.rest](https://github.com/edmundpf/mongoose-auto-api-rest/blob/master/README.md)

## Populate and Access Data
* Use the Rest API to populate and access your data in any language of choice using web requests **OR...**
* Use the consumer module for Node.js to easily interface with your data with pre-built methods
	* [Consumer Module - mongoose-auto-api.consumer](https://github.com/edmundpf/mongoose-auto-api-consumer/blob/master/README.md)
	
## Using the Web App
* You can test your own custom components alongside the included CRUD app in dev mode
* Serve in production mode when ready
* The Web App/Rest API will be served according to your *appConfig.json* specifications (which can be edited with the CLI)
* Your secret key must be created first with the CLI or via the API to add a user, this is for security purposes

### Sign Up
* Create a user using your secret key

![PWA - Sign Up](https://i.imgur.com/yM9lgjM.gif "PWA - Sign Up")

### View/Edit your collections
* Click the *Data Models* option in the menu. Your collections will be automatically populated.
* Click a collection to view/edit your data

### Create an item
* Click the *Create* button

![PWA - Create Item](https://i.imgur.com/rZf0Xx5.gif "PWA - Create Item")

### Edit an item
* Click the *pencil* icon for the respective item

![PWA - Edit Item](https://i.imgur.com/s5orJSb.gif "PWA - Edit Item")

### View item detail
* Click the *eye* icon for the respective item

![PWA - View Item Detail](https://i.imgur.com/TOOlAjs.gif "PWA - View Item Detail")

### Delete an item
* Click the *trash* icon for the respective item

![PWA - Delete Item](https://i.imgur.com/ek8MzGa.gif "PWA - Delete Item")

### Array items - creation
* The API and Web app automatically parse comma-separated strings into an array during document creation
	* i.e. `apples,pears -> ['apples', 'pears']`
	
![PWA - Array Creation](https://i.imgur.com/BYhiIJ1.gif "PWA - Array Creation")

### Array items - Push option
* The push option pushes items into the array, regardless of if the item is unique or not

![PWA - Array Push](https://i.imgur.com/tPdKwYr.gif "PWA - Array Push")

### Array items - Unique option
* The unique option pushes only unique items into the array

![PWA - Array Unique](https://i.imgur.com/wHh8KUm.gif "PWA - Array Unique")

### Array items - Set option
* The unique option pushes only unique items into the array

![PWA - Array Set](https://i.imgur.com/U4vRRsF.gif "PWA - Array Set")

### Error feedback
* The create, update, and delete dialogs will display error feedback from the database

![PWA - Error Feedback](https://i.imgur.com/mQaEb8a.gif "PWA - Error Feedback")

### Filter items
* Items can be queried with a number of operators
	* See the *find* endpoint in the Rest API documentation for a list of operators
		* [Rest API Module - mongoose-auto-api.rest](https://github.com/edmundpf/mongoose-auto-api-rest/blob/master/README.md)
* Click the *Filter* button to launch the filter dialog
* Click the *Add Filter* button to add a filter
	* Filters can be removed by hitting the *X* button for the respective filter
* Click apply to apply all of the filters to the data

![PWA - Filter Items](https://i.imgur.com/T69cMFI.gif "PWA - Filter Items")

### Reset Filters
* Reset filters and get all data by clicking the *Reset* button

![PWA - Reset Filters](https://i.imgur.com/kGAfuFl.gif "PWA - Reset Filters")

### Sign Out and Auth
* Auth options can be accessed in the menu

![PWA - Sign Out and Auth](https://i.imgur.com/5qt4Qnd.gif "PWA - Sign Out and Auth")

## Issues/Contributing
* Please add any issues, feedback, or suggestions to the [Issue Tracker](https://github.com/edmundpf/nuxt_mongoose_pwa/issues)
* Submit a pull request to contribute, any contributions are welcome
