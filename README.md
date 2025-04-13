# Healthcare Blockchain Project

A blockchain-based medical records management system that enables secure and patient-controlled health information exchange between healthcare providers.

## Overview

This project implements a decentralized solution for managing medical records on the Binance Smart Chain. It allows patients to maintain ownership of their health data while granting specific doctors temporary access to their medical history.

## Technologies Used

- **Smart Contract Development**: Solidity 0.8.28
- **Development Environment**: Hardhat
- **Network**: BSC Testnet (Binance Smart Chain Testnet)
- **Tools & Libraries**:
  - Hardhat Ignition (deployment management)
  - Hardhat Toolbox (testing utilities)
  - TypeScript
  - Dotenv (environment configuration)

## Core Features

### User Management
- Patient registration and identification
- Doctor registration with specialization details
- Blockchain-based identity verification

### Access Control
- Patient-controlled permissions system
- Ability to grant and revoke doctor access
- Fine-grained control over medical record accessibility

### Medical Record Storage
- Secure storage of medical data references (hash/IPFS)
- Timestamped and signed record entries
- Comprehensive record history

### Security
- Permission-based data access
- Blockchain immutability for audit trail
- Decentralized architecture eliminating single points of failure

## Getting Started

### Prerequisites
- Node.js and npm
- Wallet with BSC testnet BNB (for deployment and testing)

### Installation
```bash
# Clone the repository
git clone [repository-url]

# Install dependencies
npm install

# Create .env file from example
cp env.example .env
# Add your private key and BSCScan API key to .env
```

### Configuration
Set up your environment variables in `.env`:
```
PRIVATE_KEY=your_wallet_private_key
BSCSCAN_API_KEY=your_bscscan_api_key
```

### Testing
```bash
npx hardhat test
```

### Deployment
```bash
npx hardhat run scripts/deploy.js --network bsctest
```

## Smart Contract Structure

The `MedicalRecords` contract includes:
- Structs for Patient, Doctor, and MedicalRecord entities
- Mappings to store relationships and permissions
- Functions for registration, record management, and access control

## Use Cases

- **Patients**: Register, add records, manage doctor access
- **Doctors**: Register, view authorized patient records, add medical data
- **Healthcare System**: Improve interoperability and patient data portability

## License

This project is licensed under the MIT License - see the LICENSE file for details.