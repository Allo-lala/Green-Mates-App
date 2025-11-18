'use client';

import { useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Send, Download } from 'lucide-react';

interface SendReceiveDialogProps {
  isOpen: boolean;
  type: 'send' | 'receive';
  onClose: () => void;
  walletAddress: string;
}

export default function SendReceiveDialog({
  isOpen,
  onClose,
  type,
  walletAddress,
}: SendReceiveDialogProps) {
  const [amount, setAmount] = useState('');
  const [recipientAddress, setRecipientAddress] = useState('');

  const handleCopyAddress = () => {
    navigator.clipboard.writeText(walletAddress);
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            {type === 'send' ? (
              <>
                <Send className="h-5 w-5 text-blue-500" />
                Send Funds
              </>
            ) : (
              <>
                <Download className="h-5 w-5 text-green-500" />
                Receive Funds
              </>
            )}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-6">
          {type === 'send' ? (
            <>
              {/* Send Form */}
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-foreground">
                    Recipient Address
                  </label>
                  <input
                    type="text"
                    value={recipientAddress}
                    onChange={(e) => setRecipientAddress(e.target.value)}
                    placeholder="0x..."
                    className="mt-2 w-full rounded-lg border border-muted bg-background px-4 py-2 text-foreground placeholder:text-muted-foreground focus:border-primary focus:outline-none"
                  />
                </div>

                <div>
                  <label className="text-sm font-medium text-foreground">
                    Amount
                  </label>
                  <div className="mt-2 flex gap-2">
                    <input
                      type="number"
                      value={amount}
                      onChange={(e) => setAmount(e.target.value)}
                      placeholder="0.00"
                      className="flex-1 rounded-lg border border-muted bg-background px-4 py-2 text-foreground placeholder:text-muted-foreground focus:border-primary focus:outline-none"
                    />
                    <select className="rounded-lg border border-muted bg-background px-4 py-2 text-foreground focus:border-primary focus:outline-none">
                      <option>CELO</option>
                      <option>cUSD</option>
                      <option>USDC</option>
                    </select>
                  </div>
                </div>

                <button className="w-full rounded-lg bg-blue-500 py-2 font-semibold text-white hover:bg-blue-600 transition-all">
                  Send
                </button>
              </div>
            </>
          ) : (
            <>
              {/* Receive Display */}
              <div className="space-y-4">
                <div className="rounded-lg bg-muted p-6 text-center">
                  <p className="text-sm text-muted-foreground mb-2">Your Wallet Address</p>
                  <p className="font-mono text-lg font-semibold text-foreground break-all">
                    {walletAddress}
                  </p>
                </div>

                <button
                  onClick={handleCopyAddress}
                  className="w-full rounded-lg bg-green-500 py-2 font-semibold text-white hover:bg-green-600 transition-all"
                >
                  Copy Address
                </button>

                <div className="rounded-lg border border-muted bg-background p-4">
                  <p className="text-sm text-muted-foreground text-center">
                    Share your wallet address with others to receive funds
                  </p>
                </div>
              </div>
            </>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
