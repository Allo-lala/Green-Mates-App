export const WALLET_TYPES = {
  METAMASK: 'metamask',
  RABBY: 'rabby',
  RAINBOW: 'rainbow',
  TRUST_WALLET: 'trustwallet',
  PHANTOM: 'phantom',
  COINBASE: 'coinbase',
} as const;

export const WALLET_CONFIGS = {
  [WALLET_TYPES.METAMASK]: {
    name: 'MetaMask',
    logo: '/logos/metamask.png',
    color: '#F6851B',
  },
  [WALLET_TYPES.RABBY]: {
    name: 'Rabby Wallet',
    logo: '/logos/rabby.png',
    color: '#8C45F8',
  },
  [WALLET_TYPES.RAINBOW]: {
    name: 'Rainbow',
    logo: '/logos/rainbow.png',
    color: '#0E76FD',
  },
  [WALLET_TYPES.TRUST_WALLET]: {
    name: 'Trust Wallet',
    logo: '/logos/trustwallet.png',
    color: '#3375BB',
  },
  [WALLET_TYPES.PHANTOM]: {
    name: 'Phantom',
    logo: '/logos/phantom.png',
    color: '#AB9FF2',
  },
  [WALLET_TYPES.COINBASE]: {
    name: 'Coinbase Wallet',
    logo: '/logos/coinbase.png',
    color: '#1652F0',
  },
};

export const COLORS = {
  primary: '#1db584',
  primaryDark: '#16a370',
  primaryLight: '#4ecb9e',
  accent: '#22c55e',
  background: '#ffffff',
  foreground: '#0f0f0f',
  muted: '#f0f0f0',
  mutedForeground: '#666666',
};
