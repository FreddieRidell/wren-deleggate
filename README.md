# wren-delEGGate
_A system for subscribing to hierarchical events in wren_
__Egg, like a bird lays an EGG__

`Dispatcher` provides an `addListener` method, that anyone who's worked with javascript will reconise. However, unlike javascript, the first argument can be a list of values like so:

```
dispatcher.addListener( [ "foo" ], callable1 )
dispatcher.addListener( [ "foo", "bar" ], callable2 )
dispatcher.addListener( [ "foo", "bar", "baz" ], callable3 )
```

You can then dispatch actions to these callables:

```
dispatcher.dispatch( [ "foo" ], action1 ) //calls callable1
dispatcher.dispatch( [ "foo", "bar" ], action2 ) //calls callable2
dispatcher.dispatch( [ "foo", "bar", "baz" ], action3 ) //calls callable3
```

This default behaviour is not very interesting, but using the flags `callDeeper` and `callShallower` unlocks advanced functionality:

```
dispatcher.callDeeper = true
dispatcher.dispatch( [ "foo" ], action1 ) //calls callable1, callable2, & callable3
dispatcher.dispatch( [ "foo", "bar" ], action2 ) //calls callable2, & callable3
dispatcher.dispatch( [ "foo", "bar", "baz" ], action3 ) //calls callable3
```

```
dispatcher.callShallower = true
dispatcher.dispatch( [ "foo" ], action1 ) //calls callable1
dispatcher.dispatch( [ "foo", "bar" ], action2 ) //calls callable1, & callable2
dispatcher.dispatch( [ "foo", "bar", "baz" ], action3 ) //calls callable1, callable2, & callable3
```

The flag `callOne` causes the dispatcher to stop after the first callable it encounters returns `truthy`.


`Dispatcher.dispatch` returns an array of all all the return values that each encountered listener returned.

## To Do:

- [ ] Event typing, let us deffine the type of the actions that can be dispatched through a given event
