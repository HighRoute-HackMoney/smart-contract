# OpenClaw Smart Contracts

Smart contracts for session settlement and revenue share on BNB testnet.

## Contracts

- **SessionSettlement**: Records trading session settlements and manages agent revenue share configuration.

## Deployment

1. Set environment variables:
   - `RPC_URL_BSC_TESTNET`: BNB testnet RPC endpoint
   - `PRIVATE_KEY`: Deployer private key

2. Compile contracts:
   ```bash
   npm run compile
   ```

3. Deploy to BNB testnet:
   ```bash
   npm run deploy:bsc-testnet
   ```

## ABI

The contract ABI is available in `artifacts/SessionSettlement.abi.json` for backend integration.
# smart-contract
