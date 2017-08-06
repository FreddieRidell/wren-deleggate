import "wren-tree/main" for Tree, Node

class DispatchPolices {
	static callDeeper     { 0x01 }
	static callOne        { 0x02 }
	static callShallower  { 0x04 }
}

class Dispatcher {
	terminal { _terminal }
	numberOfListeners { _listeners.count }
	
	flags { _flags || ( DispatchPolices.callShallower | DispatchPolices.callDeeper ) }
	callDeeper { flags & DispatchPolices.callDeeper != 0 }
	callOne { flags & DispatchPolices.callOne != 0 }
	callShallower { flags & DispatchPolices.callShallower != 0 }

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

		return Node.new("%(terminal) (%(numberOfListeners)/%(transitiveNumberOfListeners))", childNodes)
	}

	construct root() {
		_terminal = "*"
		_childDispatchers = {}
		_listeners = []
	}

	construct new(terminal) {
		_terminal = terminal
		_childDispatchers = {}
		_listeners = []
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

			_childDispatchers[head].addListener(tail, callable)
		}
	}

	dispatch(path, action, flags){
		var defaultFlags = _flags
		_flags = flags

		dispatch(path, action)

		_flags = defaultFlags
	}

	dispatch(path, action){
		if(path is String){
			return dispatch([path], action)
		}

		if(path is List){
			if(path.count == 0 || callShallower){
				for(listener in _listeners){
					var response = listener.call(action)
					if(callOne && response){
						return
					}
				}
			}

			if(path.count != 0){
				var head = path[0]
				var tail = path[1..-1]

				_childDispatchers[head].dispatch(tail, action)
			} else if(callDeeper){
				for(child in _childDispatchers.values){
					child.dispatch([], action)
				}
			}
		}
	}
}

