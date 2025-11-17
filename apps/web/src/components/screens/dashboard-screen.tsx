'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { Send, Download, Ticket, Heart, TrendingUp, History } from 'lucide-react';
import VirtualCard from '@/components/virtual-card';
import DashboardAction from '@/components/dashboard-action';
import { checkUserSession } from '@/lib/auth';

interface UserSession {
  walletAddress: string;
  walletType: string;
  timestamp: string;
}

export default function DashboardScreen() {
  const router = useRouter();
  const [session, setSession] = useState<UserSession | null>(null);
  const [balance, setBalance] = useState('2,450.50');
  const [hideBalance, setHideBalance] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const initializeDashboard = async () => {
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

    initializeDashboard();
  }, [router]);

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

  const maskAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-muted/50 to-background pb-20">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary/10 to-accent/10 px-4 py-8">
        <div className="mx-auto max-w-2xl">
          <p className="text-sm text-muted-foreground">Welcome back</p>
          <h1 className="text-2xl font-bold text-foreground">
            {maskAddress(session.walletAddress)}
          </h1>
        </div>
      </div>

      {/* Main content */}
      <div className="mx-auto max-w-2xl space-y-6 px-4 py-8">
        {/* Virtual Card */}
        <VirtualCard
          balance={hideBalance ? '***' : balance}
          hideBalance={hideBalance}
          onToggleBalance={() => setHideBalance(!hideBalance)}
          walletAddress={session.walletAddress}
        />

        {/* Quick Actions */}
        <div className="space-y-3">
          <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wide">
            Quick Actions
          </h2>
          <div className="grid gap-3 grid-cols-2 sm:grid-cols-4">
            <DashboardAction
              icon={Send}
              label="Send"
              color="from-blue-500 to-blue-600"
            />
            <DashboardAction
              icon={Download}
              label="Receive"
              color="from-green-500 to-green-600"
            />
            <DashboardAction
              icon={Ticket}
              label="Tickets"
              color="from-purple-500 to-purple-600"
            />
            <DashboardAction
              icon={Heart}
              label="Donate"
              color="from-red-500 to-red-600"
            />
          </div>
        </div>

        {/* Assets Section */}
        <div className="space-y-4 rounded-lg border border-muted bg-background p-6">
          <div className="flex items-center gap-2">
            <TrendingUp className="h-5 w-5 text-primary" />
            <h2 className="text-lg font-semibold text-foreground">Your Assets</h2>
          </div>
          
          <div className="space-y-3">
            {[
              { name: 'CELO', amount: '1,250', price: '$0.45', change: '+2.5%' },
              { name: 'cUSD', amount: '950.50', price: '$1.00', change: '+0.1%' },
              { name: 'Green Points', amount: '5,420', price: 'N/A', change: '+15.2%' },
            ].map((asset, index) => (
              <div
                key={index}
                className="flex items-center justify-between rounded-lg bg-muted p-4 hover:bg-muted/80 transition-all"
              >
                <div>
                  <p className="font-semibold text-foreground">{asset.name}</p>
                  <p className="text-sm text-muted-foreground">{asset.price}</p>
                </div>
                <div className="text-right">
                  <p className="font-semibold text-foreground">{asset.amount}</p>
                  <p className={`text-sm ${asset.change.startsWith('+') ? 'text-green-600' : 'text-red-600'}`}>
                    {asset.change}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Transactions */}
        <div className="space-y-4 rounded-lg border border-muted bg-background p-6">
          <div className="flex items-center gap-2">
            <History className="h-5 w-5 text-primary" />
            <h2 className="text-lg font-semibold text-foreground">Recent Transactions</h2>
          </div>
          
          <div className="space-y-3">
            {[
              { type: 'Received', amount: '+100 CELO', date: 'Today', time: '2:30 PM' },
              { type: 'Sent', amount: '-50 cUSD', date: 'Yesterday', time: '4:15 PM' },
              { type: 'Earned', amount: '+250 Green Points', date: 'Dec 15', time: '10:00 AM' },
            ].map((tx, index) => (
              <div
                key={index}
                className="flex items-center justify-between rounded-lg bg-muted p-4"
              >
                <div>
                  <p className="font-medium text-foreground">{tx.type}</p>
                  <p className="text-sm text-muted-foreground">{tx.date}</p>
                </div>
                <div className="text-right">
                  <p className={`font-semibold ${tx.amount.startsWith('+') ? 'text-green-600' : 'text-foreground'}`}>
                    {tx.amount}
                  </p>
                  <p className="text-xs text-muted-foreground">{tx.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
