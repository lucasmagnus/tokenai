import { StellarPlus } from "stellar-plus"

export const KEYS = {
  issuerPK: process.env.ISSUER_PK,
  issuerSK: process.env.ISSUER_SK,
  distributorPK: process.env.DISTRIBUTOR_PK,
  distributorSK: process.env.DISTRIBUTOR_SK,
}

export const CONFIG = {
  network: StellarPlus.Network.TestNet(),
  horizonUrl: "https://horizon-testnet.stellar.org"
}