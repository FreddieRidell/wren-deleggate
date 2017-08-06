import "./main" for Dispatcher, DispatchPolices

/*
├── foo
│   ├── 1
│   ├── 2
│   └── bar
│       └── 3
└── qux
    └── 4
*/

var dispatcher = Dispatcher.root()

dispatcher.addListener("foo", Fn.new { |action|
	System.print("(1) action: %(action)")
})
dispatcher.addListener("foo", Fn.new { |action|
	System.print("(2) action: %(action)")
	return true
})
dispatcher.addListener(["foo", "bar"], Fn.new { |action|
	System.print("(3) action: %(action)")
})
dispatcher.addListener("qux", Fn.new { |action|
	System.print("(4) action: %(action)")
})

System.print(dispatcher)

dispatcher.dispatch("foo", "x")
dispatcher.dispatch(["foo", "bar"], "y")
dispatcher.dispatch("qux", "z")
