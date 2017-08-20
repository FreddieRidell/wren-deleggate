import "wren-tree/main" for Tree, Node

class DispatchPolices {
	static callDeeper     { 0x01 }
	static callOne        { 0x02 }
	static callShallower  { 0x04 }
}

class Dispatcher {
	terminal { _terminal }
	numberOfListeners { _listeners.count }

	flags { _flags }
	flags=(val){ _flags = val }
	callDeeper { ( flags & DispatchPolices.callDeeper ) != 0 }
	callOne { ( flags & DispatchPolices.callOne ) != 0 }
	callShallower { ( flags & DispatchPolices.callShallower ) != 0 }

	callDeeper=(val){
		if(val) {
			_flags = _flags | DispatchPolices.callDeeper
		} else {
			_flags = _flags & ( ~DispatchPolices.callDeeper )
		}
	}

	callOne=(val){
		if(val) {
			_flags = _flags | DispatchPolices.callOne
		} else {
			_flags = _flags & ( ~DispatchPolices.callOne )
		}
	}

	callShallower=(val){
		if(val) {
			_flags = _flags | DispatchPolices.callShallower
		} else {
			_flags = _flags & ( ~DispatchPolices.callShallower )
		}
	}

	transitiveNumberOfListeners {
		var n = numberOfListeners

		for(child in _childDispatchers.values){
			n = n + child.transitiveNumberOfListeners
		}

		return n
	}

	toString { "%(treeify())" }

	treeify(){
		var childNodes = []

		for(child in _childDispatchers.values){
			childNodes.add(child.treeify())
		}

		//return Node.new("%(terminal) (%(numberOfListeners)/%(transitiveNumberOfListeners))", childNodes)
		return Node.new("%(terminal)", childNodes)
	}

	construct root() {
		_childDispatchers = {}
		_flags = 0
		_listeners = []
		_terminal = ""
		_root = true
	}

	construct root(name) {
		_childDispatchers = {}
		_flags = 0
		_listeners = []
		_terminal = name
		_root = true
	}

	construct new(terminal) {
		_childDispatchers = {}
		_flags = 0
		_listeners = []
		_terminal = terminal
	}

	addListener(path, callable){
		if(path is String){
			return addListener([path], callable)
		}

		if(path is List){
			if(path.count == 0){
				return _listeners.add(callable)
			}

			var head = path[0]
			var tail = path[1..-1]

			if(!_childDispatchers[head]){
				_childDispatchers[head] = Dispatcher.new(head)
			}

			return _childDispatchers[head].addListener(tail, callable)
		}
	}

	dispatch(path, action){
		return dispatch(path, action, flags)
	}

	dispatch(path, action, callFlags){
		_flags = callFlags

		if(path is String){
			return dispatch([path], action, callFlags)
		}

		var results = []
		if(path is List){
			if(path.count == 0 || callShallower){
				for(listener in _listeners){
					results.add(listener.call(action))
					if(results[-1] && callOne){
						return results
					}
				}
			}

			if(path.count != 0){ 
				var head = path[0]
				var tail = path[1..-1]

				if(!_childDispatchers[head]){
					Fiber.abort("invalid path %(path)")
				}

				results.addAll(_childDispatchers[head].dispatch(tail, action, callFlags))

				return results
			}

			if(callDeeper){
				_childDispatchers.values.each { |cd| cd.dispatch([], action, callFlags) }
			}
		}

		return results
	}
}
