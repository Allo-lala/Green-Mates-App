'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Loader2 } from 'lucide-react';
import WalletCard from '@/components/wallet-card';
import { WALLET_CONFIGS, WALLET_TYPES } from '@/lib/constants';
import { connectWallet } from '@/lib/wallet';
import { saveUserSession } from '@/lib/auth';

export default function WalletConnectionScreen() {
  const router = useRouter();
  const [selectedWallet, setSelectedWallet] = useState<string | null>(null);
  const [isConnecting, setIsConnecting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleWalletSelect = async (walletType: string) => {
    setSelectedWallet(walletType);
    setError(null);
    setIsConnecting(true);

    try {
      const address = await connectWallet(walletType);
      if (address) {
        await saveUserSession(address, walletType);
        router.push('/kyc');
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Connection failed');
      setSelectedWallet(null);
    } finally {
      setIsConnecting(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted px-4 py-8">
      <div className="mx-auto max-w-2xl">
        {/* Header */}
        <div className="mb-12 text-center">
          <h1 className="text-4xl font-bold text-foreground mb-3">
            Connect Your Wallet
          </h1>
          <p className="text-lg text-muted-foreground">
            Choose your preferred crypto wallet to get started with GreenMates
          </p>
        </div>

        {/* Error message */}
        {error && (
          <div className="mb-6 rounded-lg border border-red-300 bg-red-50 p-4 text-red-700">
            {error}
          </div>
        )}

        {/* Wallet grid */}
        <div className="grid gap-4 sm:grid-cols-2 md:grid-cols-3">
          {Object.entries(WALLET_CONFIGS).map(([key, config]) => (
            <WalletCard
              key={key}
              walletType={key}
              config={config}
              isSelected={selectedWallet === key}
              isLoading={isConnecting && selectedWallet === key}
              onSelect={() => handleWalletSelect(key)}
              disabled={isConnecting && selectedWallet !== key}
            />
          ))}
        </div>

        {/* Info text */}
        <div className="mt-12 rounded-lg border border-primary/20 bg-primary/5 p-6 text-center">
          <p className="text-sm text-muted-foreground">
            We support MetaMask, Rabby, Rainbow, Trust Wallet, Phantom, and Coinbase Wallet. More wallets coming soon.
          </p>
        </div>
      </div>
    </div>
  );
}
