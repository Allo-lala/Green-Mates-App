'use client';

import { usePrivy } from '@privy-io/react-auth';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';
import { Wallet, Loader2 } from 'lucide-react';

export default function WalletConnectionScreen() {
  const { login, authenticated, user, ready } = usePrivy();
  const router = useRouter();

  useEffect(() => {
    if (authenticated && user) {
      router.push('/kyc');
    }
  }, [authenticated, user, router]);

  const handleConnect = async () => {
    try {
      await login();
    } catch (error) {
      console.error('[ Privy login error:', error);
    }
  };

  if (!ready) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-[#1db584]" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#1db584]/10 to-[#15a576]/10 px-4 py-8">
      <div className="mx-auto max-w-2xl">
        <div className="mb-12 text-center">
          <div className="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-[#1db584]">
            <Wallet className="h-10 w-10 text-white" />
          </div>
          <h1 className="mb-3 text-4xl font-bold text-gray-900">
            Connect Your Wallet
          </h1>
          <p className="text-lg text-gray-600">
            Choose your preferred crypto wallet to get started with Grin Mates
          </p>
        </div>

        <div className="rounded-2xl bg-white p-8 shadow-xl">
          <button
            onClick={handleConnect}
            className="w-full rounded-xl bg-[#1db584] px-6 py-4 text-lg font-semibold text-white transition-all hover:bg-[#1db584]/90 hover:shadow-lg"
          >
            Connect Wallet
          </button>

          <div className="mt-6 rounded-lg p-4">
            <p className="text-center text-sm text-gray-600">
              Engage • Empower • Earn
            </p>
          </div>
        </div>

        <p className="mt-8 text-center text-sm text-gray-500">
          By connecting, you agree to our Terms of Service and Privacy Policy
        </p>
      </div>
    </div>
  );
}
