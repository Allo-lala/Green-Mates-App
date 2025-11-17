'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import OnboardingScreen from '@/components/screens/onboarding-screen';
import { checkUserSession } from '@/lib/auth';

export default function Home() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(true);
  const [showOnboarding, setShowOnboarding] = useState(true);

  useEffect(() => {
    const initializeApp = async () => {
      try {
        const session = await checkUserSession();
        if (session) {
          setShowOnboarding(false);
          router.push('/dashboard');
        } else {
          setShowOnboarding(true);
        }
      } catch (error) {
        console.error('Error checking session:', error);
        setShowOnboarding(true);
      } finally {
        setIsLoading(false);
      }
    };

    initializeApp();
  }, [router]);

  if (isLoading) {
    return (
      <div className="flex h-screen items-center justify-center bg-gradient-to-br from-primary to-primary-light">
        <div className="space-y-4 text-center text-white">
          <div className="h-12 w-12 animate-spin rounded-full border-4 border-white border-t-transparent mx-auto"></div>
          {/* <p className="text-lg font-semibold">Loading </p> */}
        </div>
      </div>
    );
  }

  return showOnboarding ? <OnboardingScreen /> : null;
}
