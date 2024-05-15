use core::result::ResultTrait;
use starknet::{ContractAddress};
use snforge_std::{declare, cheatcodes::contract_class::ContractClassTrait};

mod Errors {
    const NOT_EQUAL: felt252 = 'Stored value not equal';
    const NOT_INCREASED: felt252 = 'Value not increased';
}

fn deploy_contract(initial_value: u32, kill_switch: bool) -> ContractAddress {
    let contract = declare("KillSwitch").unwrap();
    let constructor_args = array![kill_switch.into()];
    let (kill_switch_address, _) = contract.deploy(@constructor_args).unwrap();

    let contract = declare("Counter").unwrap();
    let constructor_args = array![initial_value.into(), kill_switch_address.into()];
    let (counter_contract_address, _) = contract.deploy(@constructor_args).unwrap();
    return counter_contract_address;
}
