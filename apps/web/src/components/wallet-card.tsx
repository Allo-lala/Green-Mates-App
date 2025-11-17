'use client';

import Image from 'next/image';
import { Loader2, Check } from 'lucide-react';
import { cn } from '@/lib/utils';

interface WalletCardProps {
  walletType: string;
  config: {
    name: string;
    logo: string;
    color: string;
  };
  isSelected: boolean;
  isLoading: boolean;
  onSelect: () => void;
  disabled: boolean;
}

export default function WalletCard({
  config,
  isSelected,
  isLoading,
  onSelect,
  disabled,
}: WalletCardProps) {
  return (
    <button
      onClick={onSelect}
      disabled={disabled || isLoading}
      className={cn(
        'group relative overflow-hidden rounded-xl border-2 p-6 text-center transition-all duration-300',
        isSelected
          ? 'border-primary bg-primary/10 shadow-lg shadow-primary/30'
          : 'border-muted bg-background hover:border-primary/50 hover:shadow-md',
        disabled && 'opacity-50 cursor-not-allowed'
      )}
    >
      {/* Background gradient on hover */}
      <div
        className="absolute inset-0 opacity-0 transition-opacity group-hover:opacity-10"
        style={{ backgroundColor: config.color }}
      />

      {/* Content */}
      <div className="relative space-y-4">
        {/* Logo */}
        <div className="flex justify-center">
          <div className="relative h-16 w-16">
            <Image
              src={config.logo || "/logo.png"}
              alt={config.name}
              fill
              className="object-contain"
            />
          </div>
        </div>

        {/* Name */}
        <h3 className="font-semibold text-foreground">{config.name}</h3>

        {/* Loading or selected state */}
        <div className="flex justify-center">
          {isLoading ? (
            <Loader2 className="h-5 w-5 animate-spin text-primary" />
          ) : isSelected ? (
            <Check className="h-5 w-5 text-primary" />
          ) : null}
        </div>
      </div>
    </button>
  );
}
