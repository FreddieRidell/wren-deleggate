import "./main" for Dispatcher, DispatchPolices

System.print("
├── foo
│   ├── 1
│   ├── 2
│   └── bar
│       └── 3
└── qux
    └── 4
")

var dispatcher = Dispatcher.root()

dispatcher.addListener("foo", Fn.new { |action|
	System.print("(1) action: %(action)")
	return "bean"
})
dispatcher.addListener("foo", Fn.new { |action|
	System.print("(2) action: %(action)")
	return true
})
dispatcher.addListener(["foo", "bar"], Fn.new { |action|
	System.print("(3) action: %(action)")
	return "(%(action))"
})
dispatcher.addListener("qux", Fn.new { |action|
	System.print("(4) action: %(action)")
})

System.print(dispatcher)

var doStuff = Fn.new { |d|
	System.print("%(d.callDeeper), %(d.callOne), %(d.callShallower)")

	System.print("\n[foo]: x")
	System.print(d.dispatch("foo", "x"))

	System.print("\n[foo, bar]: y")
	System.print(d.dispatch(["foo", "bar"], "y"))

	System.print("\n[qux]: z")
	System.print(d.dispatch("qux", "z"))
}

System.print("\n\ndefault")
doStuff.call(dispatcher)

System.print("\n\nwith call shallower")
dispatcher.callShallower = true
doStuff.call(dispatcher)

/*System.print("\n\nwith call deeper")*/
/*dispatcher.callDeeper = true*/
/*doStuff.call(dispatcher)*/

/*System.print("\n\nwith call one")*/
/*dispatcher.callOne = true*/
/*doStuff.call(dispatcher)*/
