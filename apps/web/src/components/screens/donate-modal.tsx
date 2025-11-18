'use client';

import { useState } from 'react';
import { X, Wallet, Coins, ArrowRight } from 'lucide-react';

interface DonateModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export function DonateModal({ isOpen, onClose }: DonateModalProps) {
  const [selectedMethod, setSelectedMethod] = useState<'wallet' | 'points' | null>(null);
  const [amount, setAmount] = useState('');
  const [greenPoints, setGreenPoints] = useState(1250);

  if (!isOpen) return null;

  const handleDonate = () => {
    if (selectedMethod === 'wallet') {
      console.log('[v0] Donating from wallet:', amount);
    } else if (selectedMethod === 'points') {
      console.log('[v0] Donating green points:', amount);
    }
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="relative w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">
        <button
          onClick={onClose}
          className="absolute right-4 top-4 rounded-full p-2 hover:bg-gray-100"
        >
          <X className="h-5 w-5" />
        </button>

        <h2 className="mb-6 text-2xl font-bold text-gray-900">Make a Donation</h2>

        <div className="mb-6 space-y-3">
          <button
            onClick={() => setSelectedMethod('wallet')}
            className={`w-full rounded-xl border-2 p-4 text-left transition-all ${
              selectedMethod === 'wallet'
                ? 'border-[#1db584] bg-[#1db584]/5'
                : 'border-gray-200 hover:border-gray-300'
            }`}
          >
            <div className="flex items-center gap-3">
              <div className={`rounded-full p-3 ${
                selectedMethod === 'wallet' ? 'bg-[#1db584]' : 'bg-gray-100'
              }`}>
                <Wallet className={`h-5 w-5 ${
                  selectedMethod === 'wallet' ? 'text-white' : 'text-gray-600'
                }`} />
              </div>
              <div className="flex-1">
                <p className="font-semibold text-gray-900">Donate with Wallet</p>
                <p className="text-sm text-gray-500">Use USDC or CELO</p>
              </div>
              {selectedMethod === 'wallet' && (
                <div className="h-5 w-5 rounded-full bg-[#1db584] flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-white" />
                </div>
              )}
            </div>
          </button>

          <button
            onClick={() => setSelectedMethod('points')}
            className={`w-full rounded-xl border-2 p-4 text-left transition-all ${
              selectedMethod === 'points'
                ? 'border-[#1db584] bg-[#1db584]/5'
                : 'border-gray-200 hover:border-gray-300'
            }`}
          >
            <div className="flex items-center gap-3">
              <div className={`rounded-full p-3 ${
                selectedMethod === 'points' ? 'bg-[#1db584]' : 'bg-gray-100'
              }`}>
                <Coins className={`h-5 w-5 ${
                  selectedMethod === 'points' ? 'text-white' : 'text-gray-600'
                }`} />
              </div>
              <div className="flex-1">
                <p className="font-semibold text-gray-900">Donate with Green Points</p>
                <p className="text-sm text-gray-500">Available: {greenPoints} points</p>
              </div>
              {selectedMethod === 'points' && (
                <div className="h-5 w-5 rounded-full bg-[#1db584] flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-white" />
                </div>
              )}
            </div>
          </button>
        </div>

        {selectedMethod && (
          <div className="mb-6">
            <label className="mb-2 block text-sm font-medium text-gray-700">
              Amount {selectedMethod === 'points' ? '(Points)' : '(USDC)'}
            </label>
            <input
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="Enter amount"
              className="w-full rounded-lg border border-gray-300 px-4 py-3 focus:border-[#1db584] focus:outline-none focus:ring-2 focus:ring-[#1db584]/20"
            />
            {selectedMethod === 'points' && amount && parseInt(amount) > greenPoints && (
              <p className="mt-1 text-sm text-red-500">Insufficient green points</p>
            )}
          </div>
        )}

        <div className="flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 rounded-lg border border-gray-300 px-4 py-3 font-semibold text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </button>
          <button
            onClick={handleDonate}
            disabled={!selectedMethod || !amount || (selectedMethod === 'points' && parseInt(amount) > greenPoints)}
            className="flex-1 rounded-lg bg-[#1db584] px-4 py-3 font-semibold text-white hover:bg-[#1db584]/90 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            Donate
            <ArrowRight className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  );
}

export default DonateModal;
