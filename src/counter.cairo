#[starknet::interface]
trait ICounter<T> {
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T);
}

#[starknet::contract]
mod Counter {
    use super::ICounter;
    use starknet::ContractAddress;
    use kill_switch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait };

    #[storage]
    struct Storage {
        counter: u32,
        kill_switch: IKillSwitchDispatcher,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        counter: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_counter: u32, kill_switch_address: ContractAddress) {
        self.counter.write(init_counter);
        let kill_switch = IKillSwitchDispatcher { contract_address: kill_switch_address };
        self.kill_switch.write(kill_switch);
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            let kill_switch = self.kill_switch.read();
            if (kill_switch.is_active()) {
                let current_counter = self.counter.read();
                let new_counter = current_counter + 1;
                self.counter.write(new_counter);
                self.emit(CounterIncreased{ counter: new_counter })

            }
        }
    }

}