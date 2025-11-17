import { WALLET_TYPES } from './constants';

export async function connectWallet(walletType: string): Promise<string | null> {
  // For development/testing, we'll simulate wallet connections
  if (walletType === WALLET_TYPES.RAINBOW) {
    return simulateRainbowConnection();
  }

  // MetaMask connection
  if (walletType === WALLET_TYPES.METAMASK) {
    return await connectMetaMask();
  }

  // Other wallet connections can be implemented here
  throw new Error(`Wallet ${walletType} not yet implemented`);
}

async function connectMetaMask(): Promise<string> {
  if (typeof window === 'undefined' || !window.ethereum) {
    throw new Error('MetaMask not installed');
  }

  try {
    const accounts = await window.ethereum.request({
      method: 'eth_requestAccounts',
    }) as string[];

    if (accounts.length === 0) {
      throw new Error('No accounts found');
    }

    return accounts[0];
  } catch (error) {
    throw new Error('Failed to connect MetaMask');
  }
}

function simulateRainbowConnection(): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => {
      // Generate a mock Ethereum address
      const mockAddress = '0x' + Array(40)
        .fill(0)
        .map(() => Math.floor(Math.random() * 16).toString(16))
        .join('');
      resolve(mockAddress);
    }, 1500);
  });
}

declare global {
  interface Window {
    ethereum?: any;
  }
}
