use super::utils::{deploy_contract, Errors};
use kill_switch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
use counter::counter::{ICounterDispatcher, ICounterDispatcherTrait};
use snforge_std::{
    spy_events,
    EventSpyAssertionsTrait, 
    EventSpyTrait,
    Event,
};

#[test]
fn test_counter_event() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = ICounterDispatcher { contract_address };

    let mut spy = spy_events();

    dispatcher.increase_counter();

    let events = spy.get_events();

    assert(events.events.len() == 1, 'There should be one event');

    let (from, event) = events.events.at(0);

    assert(from == @contract_address, 'Emitted from wrong address');

    assert(event.keys.len() == 1, 'There should be one key');

    assert(event.keys.at(0) == @selector!("CounterIncreased"), 'Wrong event name');

    assert(event.data.len() == 1, 'There should be one data');
}
