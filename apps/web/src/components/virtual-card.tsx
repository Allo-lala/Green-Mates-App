'use client';

import { Eye, EyeOff, Copy } from 'lucide-react';
import { useState } from 'react';

interface VirtualCardProps {
  balance: string;
  hideBalance: boolean;
  onToggleBalance: () => void;
  walletAddress: string;
}

export default function VirtualCard({
  balance,
  hideBalance,
  onToggleBalance,
  walletAddress,
}: VirtualCardProps) {
  const [copied, setCopied] = useState(false);

  const handleCopyAddress = () => {
    navigator.clipboard.writeText(walletAddress);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="group relative overflow-hidden rounded-2xl bg-gradient-to-br from-primary via-primary-dark to-primary-light p-8 text-white shadow-xl hover:shadow-2xl transition-all duration-300">
      {/* Background decoration */}
      <div className="absolute -right-12 -top-12 h-40 w-40 rounded-full bg-white/10 blur-3xl" />
      <div className="absolute -bottom-8 -left-8 h-32 w-32 rounded-full bg-white/10 blur-3xl" />

      {/* Content */}
      <div className="relative space-y-8">
        {/* Header */}
        <div className="flex items-start justify-between">
          <div>
            <p className="text-sm font-semibold text-white/80 uppercase tracking-widest">
              GreenMates Wallet
            </p>
            <h2 className="text-2xl font-bold text-white mt-1">Engage. Empower. Earn.</h2>
          </div>
          <button
            onClick={onToggleBalance}
            className="rounded-lg bg-white/20 p-2 hover:bg-white/30 transition-all"
          >
            {hideBalance ? (
              <EyeOff className="h-5 w-5 text-white" />
            ) : (
              <Eye className="h-5 w-5 text-white" />
            )}
          </button>
        </div>

        {/* Balance */}
        <div>
          <p className="text-sm text-white/80 font-medium">Total Balance</p>
          <p className="text-4xl font-bold text-white mt-2 tracking-tight">
            {hideBalance ? '•••••' : `$${balance}`}
          </p>
        </div>

        {/* Wallet Address */}
        <div className="flex items-center justify-between">
          <div>
            <p className="text-xs text-white/70 uppercase tracking-wider">Wallet Address</p>
            <p className="text-sm font-mono text-white/90 mt-1">
              {`${walletAddress.slice(0, 6)}...${walletAddress.slice(-6)}`}
            </p>
          </div>
          <button
            onClick={handleCopyAddress}
            className="rounded-lg bg-white/20 p-2 hover:bg-white/30 transition-all"
            title={copied ? 'Copied!' : 'Copy address'}
          >
            <Copy className="h-5 w-5 text-white" />
          </button>
        </div>

        {/* Card Number */}
        <div className="border-t border-white/20 pt-6">
          <p className="text-xs text-white/70 uppercase tracking-wider">Card Number</p>
          <p className="text-lg font-mono text-white/90 mt-2 tracking-widest">
            {hideBalance ? '•••• •••• •••• ••••' : '1234 5678 9012 3456'}
          </p>
        </div>
      </div>
    </div>
  );
}
