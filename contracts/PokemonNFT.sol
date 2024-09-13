// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PokemonNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Pokemon {
        string name;
        uint attack;
        uint defense;
        uint hp;
    }

    mapping(uint256 => Pokemon) public pokemons;
    mapping(uint256 => uint256) public pokemonHp;

    constructor() ERC721("PokemonNFT", "PKMN") {}

    /**
     * Função para criar um novo Pokémon.
     * Apenas o proprietário pode criar novos Pokémons.
     */
    function createPokemon(string memory name, uint attack, uint defense, uint hp) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        
        // Criar novo Pokémon com os atributos definidos
        pokemons[newItemId] = Pokemon(name, attack, defense, hp);
        pokemonHp[newItemId] = hp;

        // Emitir um novo NFT para representar o Pokémon
        _mint(msg.sender, newItemId);

        return newItemId;
    }

    /**
     * Função de batalha entre dois Pokémons.
     */
    function battle(uint256 pokemon1Id, uint256 pokemon2Id) public {
        require(_exists(pokemon1Id), "Pokemon 1 does not exist.");
        require(_exists(pokemon2Id), "Pokemon 2 does not exist.");
        require(pokemonHp[pokemon1Id] > 0, "Pokemon 1 is fainted.");
        require(pokemonHp[pokemon2Id] > 0, "Pokemon 2 is fainted.");

        Pokemon storage pokemon1 = pokemons[pokemon1Id];
        Pokemon storage pokemon2 = pokemons[pokemon2Id];

        uint256 damageToP2 = calculateDamage(pokemon1.attack, pokemon2.defense);
        uint256 damageToP1 = calculateDamage(pokemon2.attack, pokemon1.defense);

        if (pokemonHp[pokemon2Id] > damageToP2) {
            pokemonHp[pokemon2Id] -= damageToP2;
        } else {
            pokemonHp[pokemon2Id] = 0;
        }

        if (pokemonHp[pokemon1Id] > damageToP1) {
            pokemonHp[pokemon1Id] -= damageToP1;
        } else {
            pokemonHp[pokemon1Id] = 0;
        }
    }

    function calculateDamage(uint attack, uint defense) internal pure returns (uint256) {
        if (attack > defense / 2) {
            return attack - defense / 2;
        } else {
            return 1;
        }
    }

    function isFainted(uint256 pokemonId) public view returns (bool) {
        return pokemonHp[pokemonId] == 0;
    }

    function getHp(uint256 pokemonId) public view returns (uint256) {
        return pokemonHp[pokemonId];
    }
}
