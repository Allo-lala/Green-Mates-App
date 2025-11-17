import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export async function checkUserSession() {
  try {
    const session = localStorage.getItem('greenmates_session');
    if (session) {
      const parsed = JSON.parse(session);
      return parsed;
    }
    return null;
  } catch (error) {
    console.error('Error checking session:', error);
    return null;
  }
}

export async function saveUserSession(walletAddress: string, walletType: string) {
  const session = {
    walletAddress,
    walletType,
    timestamp: new Date().toISOString(),
  };
  localStorage.setItem('greenmates_session', JSON.stringify(session));
  return session;
}

export async function clearUserSession() {
  localStorage.removeItem('greenmates_session');
}
