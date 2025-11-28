# Simple Voting DApp

## Contract Address
`0xe5B0EF1B433d844C57767E9B1C0A9EDfA9E623b3`  
Explorer: https://coston2-explorer.flare.network/address/0xe5B0EF1B433d844C57767E9B1C0A9EDfA9E623b3

## Description
This repository provides a minimal, beginner-friendly front-end integration for an on-chain **voting** smart contract deployed at the address above. The contract exposes a predefined list of candidates (set in the contract constructor) and allows each wallet address to cast a single vote for a candidate by name.

Included in this project:
- `lib/contract.ts` — contains the deployed contract address and the ABI used by viem/wagmi.
- `hooks/useContract.ts` — a React hook (`useVotingContract`) that wraps essential read and write interactions with the contract (fetching candidate count, checking if the connected address has voted, submitting votes) and manages transaction lifecycle (pending, confirming, confirmed).
- `components/sample.tsx` — a small React UI demonstrating wallet gating, listing candidates, showing vote counts, and allowing users to vote by clicking a candidate or entering a candidate name.

This scaffold aims to be a straightforward starting point for learning how to connect a Solidity contract to a React UI using Wagmi and Viem.

## Features
- Typed contract ABI and deployed address pre-configured for the target network (Coston2/Flare testnet).
- Read functions:
  - `getCandidatesCount()` — returns the number of candidates configured.
  - `candidates(index)` — returns the name of the candidate at the provided index.
  - `votes(candidate)` — returns the vote count for a candidate.
  - `hasVoted(address)` — returns whether a given address has already voted.
- Write function:
  - `vote(string candidate)` — allows a connected wallet to cast a vote for the specified candidate (one vote per address).
- Transaction lifecycle support:
  - Shows pending and confirming states, transaction hash, and confirmation messages.
  - Automatically refetches read data after successful confirmation.
- User experience improvements:
  - Wallet gating — requires wallet connection before interacting.
  - Disabled controls when voting is not allowed or the contract is not configured.
  - Per-candidate rows that fetch current vote totals and provide a Vote button.

## How It Solves
### Problem
Traditional voting systems can be centralized and non-transparent. This DApp demonstrates a simple trust-minimized approach where votes and counts are stored on-chain, offering transparency and auditability.

### Solution
By exposing candidate names and vote totals on-chain and enabling wallet-signed `vote` transactions, the system:
- Ensures each wallet can only vote once (enforced by the smart contract).
- Provides a public, auditable tally of votes.
- Keeps the client-side logic simple and focused on UX and transaction handling.

### Use Cases & Benefits
- Classroom demos and tutorials combining Solidity + Wagmi + Viem.
- Small community polls where one wallet = one vote.
- Lightweight governance or decision-making mechanisms that prioritize transparency.

## Next Steps
1. Verify the contract ABI matches the deployed contract; if the contract is redeployed or changed, update the ABI in `lib/contract.ts`.
2. Ensure users connect their wallet to the Coston2/Flare testnet to interact with the contract.
3. Optional improvements:
   - Emit events (e.g., `Voted`) in the Solidity contract and listen to them in the UI for real-time updates.
   - Add voting windows (start/end timestamps) to the contract and reflect that in the UI.
   - Add admin-controlled candidate management if needed.

## Quick Start
1. Install dependencies (Next.js, Wagmi, Viem).
2. Run the app, connect a wallet on the correct network, and vote.

**Notes**
- The UI disables voting actions when the connected address has already voted or if the contract address is not properly configured.
- Transactions may take a short time to confirm depending on network conditions; the UI displays transaction status and hash for user reference.


