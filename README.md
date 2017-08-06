# wren-delEGGate
_A system for subscribing to hierarchical events in wren_
__Egg, like a bird lays an EGG__

You can atach a listener to an event, and then call `Callable`s based on those events.
The `Dispatcher` can be configured to call callbacks some More specific events, Less specific events, and to stop at the first callback to return truthy

## To Do:

- [ ] Event typing, let us deffine the type of the actions that can be dispatched through a given event
