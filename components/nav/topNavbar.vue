<template>
	<div>
		<v-navigation-drawer
			app
			fixed
			temporary
			color="primary"
			v-model="showDrawer"
		>
			<v-list>
				<v-list-item
					v-for="(item, i) in drawerItems"
					v-if="showDrawerItem(item)"
					:key="i"
					:to="item.to"
					exact
				>
					<v-list-item-action>
						<v-icon>{{ item.icon }}</v-icon>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title v-text="item.title" />
					</v-list-item-content>
				</v-list-item>
			</v-list>

			<template v-slot:append>

				<div
					class="pa-2"
					v-for="(item, i) in authItems"
					v-show="$store.state.nav[item.stateKey]"
					:key="i"
				>
					<v-btn
						block
						:class="attrCheck(item.class)"
						:to="attrCheck(item.to)"
						@click.stop="item.action != null ? item.action() : null"
					>
						<v-icon
							left
							v-if="item.icon != null"
						>
							{{ item.icon }}
						</v-icon>
						{{ authButtonText(item) }}
					</v-btn>
				</div>

			</template>
		</v-navigation-drawer>

		<v-app-bar
			app
			fixed
			dense
			color="primary"
		>
			<v-app-bar-nav-icon @click.stop="toggleDrawer()" />
			<v-btn
				icon
				v-show="showBackButton"
				@click.stop="backButtonAction()"
			>
				<v-icon>mdi-arrow-left</v-icon>
			</v-btn>
			<v-toolbar-title v-text="siteTitle" />
			<div class="flex-grow-1" />
			<v-btn icon>
				<v-icon>mdi-dots-vertical</v-icon>
			</v-btn>
		</v-app-bar>
	</div>
</template>

<script lang="coffee">

	import { titleCase } from '~/modules/miscUtils'

	export default

		data: ->
			return
				siteTitle: if this.$route.name != null then this.getSiteTitle(this.$route.name) else 'Error'
				showBackButton: if this.$route.name != null then this.hasBackButton(this.$route.name) else true
				showDrawer: false
				drawerItems: [
					{
						title: 'Home',
						icon: 'mdi-home',
						to: '/'
					}
					{
						title: 'Data Models',
						icon: 'mdi-table',
						to: '/data/dataModels'
						auth: true
					}
				]
				authItems:
					login:
						'title': 'Log In'
						'icon': 'mdi-login'
						'class': 'accent'
						'to': '/account/login'
						'stateKey': 'showLogin'
					signUp:
						'title': 'Sign Up'
						'icon': 'mdi-account-plus'
						'class': 'secondary'
						'to': '/account/signup'
						'stateKey': 'showSignup'
					signOut:
						'title': 'Sign Out'
						'icon': 'mdi-logout'
						'action': this.signOutAction
						'stateKey': 'showSignout'

		watch:
			'$route.name': (value) ->
				this.siteTitle = this.getSiteTitle(value)
				this.showBackButton = this.hasBackButton(value)

		methods:

			# Assert attribute is not null

			attrCheck: (attr) ->
				return (if attr != null then attr else null)

			# Toggle Menu Drawer

			toggleDrawer: ->
				this.showDrawer = !this.showDrawer

			# Get Site Title for Navbar

			getSiteTitle: (value) ->
				aliases =
					index: 'Home'
				if Object.keys(aliases).includes(value)
					return aliases[value]
				else
					routePaths = value.split('-')
					return titleCase(routePaths[routePaths.length - 1])

			# Has Back Button

			hasBackButton: (value) ->
				omitPaths = [
					'index'
				]
				omitMatches = [
					'account'
				]
				if omitPaths.includes(value) or omitMatches.includes(value.split('-')[0])
					return false
				else
					return true

			# Get Auth Button Text

			authButtonText: (item) ->
				if item.icon?
					return " #{item.title}"
				else
					return item.title

			# Show Drawer Item

			showDrawerItem: (item) ->
				if !item.auth?
					return true
				else if item.auth? and !item.auth
					return true
				else if item.auth? and item.auth and this.$store.state.auth.loggedIn
					return true
				else
					return false

			# Back Button Action

			backButtonAction: ->
				this.$router.back()

			# Sign Out Action

			signOutAction: ->
				this.$store.dispatch(
					'auth/setState'
					loggedIn: false
					remember: false
					accessToken: ''
				)
				this.$router.push('/account/login')

</script>