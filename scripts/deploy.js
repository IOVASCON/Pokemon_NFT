const PokemonNFT = artifacts.require("PokemonNFT");

module.exports = async function(deployer) {
  // Faça o deploy do contrato NFT de Pokémon
  await deployer.deploy(PokemonNFT);
};
