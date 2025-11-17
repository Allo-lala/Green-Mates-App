'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { User, Copy, Check, LogOut } from 'lucide-react';
import { checkUserSession, clearUserSession } from '@/lib/auth';

interface UserSession {
  walletAddress: string;
  walletType: string;
  timestamp: string;
}

export default function ProfileScreen() {
  const router = useRouter();
  const [session, setSession] = useState<UserSession | null>(null);
  const [copied, setCopied] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const initializeProfile = async () => {
      try {
        const userSession = await checkUserSession();
        if (!userSession) {
          router.push('/wallet-connect');
          return;
        }
        setSession(userSession);
      } finally {
        setIsLoading(false);
      }
    };

    initializeProfile();
  }, [router]);

  const handleCopyAddress = () => {
    if (session) {
      navigator.clipboard.writeText(session.walletAddress);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const handleLogout = async () => {
    await clearUserSession();
    router.push('/wallet-connect');
  };

  if (isLoading) {
    return (
      <div className="flex h-screen items-center justify-center">
        <div className="h-12 w-12 animate-spin rounded-full border-4 border-primary border-t-transparent" />
      </div>
    );
  }

  if (!session) {
    return null;
  }

  const getWalletName = (type: string) => {
    const names: Record<string, string> = {
      metamask: 'MetaMask',
      rabby: 'Rabby Wallet',
      rainbow: 'Rainbow',
      trustwallet: 'Trust Wallet',
      phantom: 'Phantom',
      coinbase: 'Coinbase Wallet',
    };
    return names[type] || type;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted pb-20">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary/10 to-accent/10 px-4 py-8">
        <div className="mx-auto max-w-2xl">
          <h1 className="text-3xl font-bold text-foreground">Profile</h1>
        </div>
      </div>

      {/* Main content */}
      <div className="mx-auto max-w-2xl space-y-6 px-4 py-8">
        {/* Profile card */}
        <div className="rounded-xl border border-muted bg-background p-8 space-y-6">
          {/* Avatar placeholder */}
          <div className="flex justify-center">
            <div className="flex h-24 w-24 items-center justify-center rounded-full bg-gradient-to-br from-primary to-primary-light">
              <User className="h-12 w-12 text-white" />
            </div>
          </div>

          {/* Wallet info */}
          <div className="space-y-4">
            <div>
              <p className="text-sm text-muted-foreground font-medium">Connected Wallet</p>
              <p className="text-lg font-semibold text-foreground mt-1">
                {getWalletName(session.walletType)}
              </p>
            </div>

            {/* Wallet address */}
            <div>
              <p className="text-sm text-muted-foreground font-medium">Wallet Address</p>
              <div className="mt-2 flex items-center justify-between rounded-lg border border-muted bg-muted/50 px-4 py-3">
                <p className="font-mono text-sm text-foreground break-all">
                  {session.walletAddress}
                </p>
                <button
                  onClick={handleCopyAddress}
                  className="ml-2 flex-shrink-0 rounded-lg p-2 hover:bg-muted transition-all"
                >
                  {copied ? (
                    <Check className="h-5 w-5 text-green-600" />
                  ) : (
                    <Copy className="h-5 w-5 text-muted-foreground" />
                  )}
                </button>
              </div>
            </div>

            {/* Connection time */}
            <div>
              <p className="text-sm text-muted-foreground font-medium">Connected Since</p>
              <p className="text-foreground mt-1">
                {new Date(session.timestamp).toLocaleDateString('en-US', {
                  month: 'short',
                  day: 'numeric',
                  year: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit',
                })}
              </p>
            </div>
          </div>

          {/* Logout button */}
          <button
            onClick={handleLogout}
            className="w-full flex items-center justify-center gap-2 rounded-lg border border-red-200 bg-red-50 py-3 font-medium text-red-600 hover:bg-red-100 transition-all"
          >
            <LogOut className="h-5 w-5" />
            Disconnect Wallet
          </button>
        </div>

        {/* Account status */}
        <div className="rounded-xl border border-muted bg-background p-6 space-y-3">
          <h2 className="font-semibold text-foreground">Account Status</h2>
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <p className="text-muted-foreground">KYC Verification</p>
              <span className="inline-block rounded-full bg-green-100 px-3 py-1 text-sm font-medium text-green-700">
                Verified
              </span>
            </div>
            <div className="flex items-center justify-between">
              <p className="text-muted-foreground">Account Security</p>
              <span className="inline-block rounded-full bg-blue-100 px-3 py-1 text-sm font-medium text-blue-700">
                Standard
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
