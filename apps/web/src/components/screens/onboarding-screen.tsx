'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { ChevronRight } from 'lucide-react';
import OnboardingCard from '@/components/onboarding-card';
import onboardingImg from '@/assets/images/onboarding.png';
import lockImg from '@/assets/images/lock.png';
import ecoImg from '@/assets/images/eco.png';

const onboardingData = [
  {
    id: 1,
    title: 'Engage & Empower',
    description: 'Connect your crypto wallet and start earning rewards for sustainable actions.',
    image: onboardingImg.src,
    icon: '🌱',
  },
  {
    id: 2,
    title: 'Earn Green Points',
    description: 'Complete eco-friendly activities and earn verified digital assets on Celo.',
    image: lockImg.src,
    icon: '💚',
  },
  {
    id: 3,
    title: 'Make an Impact',
    description: 'Donate, trade, and participate in our community while protecting the planet.',
    image: ecoImg.src,
    icon: '🌍',
  },
];

export default function OnboardingScreen() {
  const router = useRouter();
  const [currentIndex, setCurrentIndex] = useState(0);

  const handleNext = () => {
    if (currentIndex < onboardingData.length - 1) {
      setCurrentIndex(currentIndex + 1);
    } else {
      router.push('/wallet-connect');
    }
  };

  const handleSkip = () => {
    router.push('/wallet-connect');
  };

  const currentData = onboardingData[currentIndex];

  return (
    <div className="flex h-screen flex-col items-center justify-center bg-gradient-to-br from-primary/5 to-accent/5 px-4">
      {/* Skip button */}
      <button
        onClick={handleSkip}
        className="absolute right-6 top-6 text-sm font-medium text-muted-foreground hover:text-foreground transition-smooth"
      >
        Skip
      </button>

      {/* Main content */}
      <div className="w-full max-w-md space-y-8">
        <OnboardingCard data={currentData} />

        {/* Page indicator */}
        <div className="flex justify-center gap-2">
          {onboardingData.map((_, index) => (
            <div
              key={index}
              className={`h-2 rounded-full transition-smooth ${
                index === currentIndex
                  ? 'w-8 bg-primary'
                  : 'w-2 bg-muted'
              }`}
            />
          ))}
        </div>

        {/* Navigation */}
        <div className="flex gap-3">
          <button
            onClick={() => setCurrentIndex(Math.max(0, currentIndex - 1))}
            disabled={currentIndex === 0}
            className="flex-1 rounded-lg border border-muted bg-background py-3 font-medium text-foreground hover:bg-muted disabled:opacity-50 transition-smooth"
          >
            Back
          </button>
          <button
            onClick={handleNext}
            className="flex-1 rounded-lg bg-gradient-to-r from-primary to-primary-light py-3 font-medium text-white hover:shadow-lg hover:shadow-primary/50 transition-smooth flex items-center justify-center gap-2"
          >
            {currentIndex === onboardingData.length - 1 ? 'Start' : 'Next'}
            <ChevronRight className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  );
}
