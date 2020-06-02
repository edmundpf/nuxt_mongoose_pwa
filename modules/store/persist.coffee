import auth from '~/modules/store/state/auth'
import nav from '~/modules/store/state/nav'

#: Get Persistent and Session Paths

paths = {
	auth,
	nav,
}

for path, val of paths
	if (!val.persist? or !val.persist) and !val.session?
		delete paths[path]

persist = []
session = []

for state, attr of paths
	if attr.persist
		pathState = attr.state()

		for path of pathState
			if !attr.session? or !attr.session.includes(path)
				if !attr.omit? or !attr.omit.includes(path)
					if state == 'index'
						persist.push(path)
					else
						persist.push("#{state}.#{path}")

		if attr.session?
			for path in attr.session
				if state == 'index'
					session.push(path)
				else
					session.push("#{state}.#{path}")

#: Exports

export {
	persist,
	session,
}

#::: End Program :::