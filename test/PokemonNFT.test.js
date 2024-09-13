const PokemonNFT = artifacts.require("PokemonNFT");

contract("PokemonNFT", (accounts) => {
  let pokemonInstance;

  before(async () => {
    pokemonInstance = await PokemonNFT.deployed();
  });

  it("deve criar um novo Pokémon", async () => {
    const result = await pokemonInstance.createPokemon("Pikachu", 55, 40, 100, { from: accounts[0] });
    assert(result, "O Pokémon foi criado com sucesso.");
  });

  it("deve executar uma batalha entre dois Pokémons", async () => {
    await pokemonInstance.createPokemon("Charmander", 52, 43, 100, { from: accounts[0] });
    await pokemonInstance.createPokemon("Squirtle", 48, 65, 100, { from: accounts[0] });

    await pokemonInstance.battle(1, 2, { from: accounts[0] });

    const hpSquirtle = await pokemonInstance.getHp(2);
    assert(hpSquirtle.toNumber() < 100, "Squirtle recebeu dano.");
  });
});
