'use client';

import Image from 'next/image';

interface OnboardingCardProps {
  data: {
    id: number;
    title: string;
    description: string;
    image: string;
    icon: string;
  };
}

export default function OnboardingCard({ data }: OnboardingCardProps) {
  return (
    <div className="space-y-6">
      {/* Image container */}
      <div className="flex h-80 items-center justify-center rounded-2xl bg-gradient-to-br from-primary/10 to-accent/10 p-8">
        <div className="relative h-full w-full">
          <Image
            src={data.image || "/onboarding.png"}
            alt={data.title}
            fill
            className="object-contain"
            priority
          />
        </div>
      </div>

      {/* Text content */}
      <div className="space-y-3 text-center">
        <div className="text-4xl">{data.icon}</div>
        <h1 className="text-3xl font-bold text-foreground text-balance">
          {data.title}
        </h1>
        <p className="text-lg text-muted-foreground text-balance">
          {data.description}
        </p>
      </div>
    </div>
  );
}
