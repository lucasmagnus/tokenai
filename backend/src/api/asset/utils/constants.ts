import { StellarPlus } from 'stellar-plus'

export const KEYS = {
  issuerPK: process.env.ISSUER_PK || 'GCN73GCPU3UVYPZKAJ2AFJM7SLJ57VUDV2E4BTSYWMNZ6SCN3SMJLLLN',
  issuerSK: process.env.ISSUER_SK || 'SBFMO3ESYNSJ2SEIPFOAXQGWNJUEWLSIZSMRHYIC3WOSYZNE2CZFLZ32',
  distributorPK: process.env.DISTRIBUTOR_PK || 'GAFWXAYWDDAWDKOZBYXQL2JII6ZJBYPRT4PM3NWU6PUAENVMRJYI7BLP',
  distributorSK: process.env.DISTRIBUTOR_SK || 'SD3TXFN75ZW75DPEYJ2OH6MLGEGNYTVAXJECEOUE2YMPNEUJTFYXTTBZ',
}

export const CONFIG = {
  network: StellarPlus.Network.TestNet(),
  horizonUrl: 'https://horizon-testnet.stellar.org',
}
