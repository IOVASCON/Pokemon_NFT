module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Endereço local do Ganache
      port: 8545,            // Porta padrão do Ganache
      network_id: "*",       // Qualquer network id
    },
  },
  compilers: {
    solc: {
      version: "0.8.19",     // Atualize para uma versão superior a 0.8.1
    }
  }
};
