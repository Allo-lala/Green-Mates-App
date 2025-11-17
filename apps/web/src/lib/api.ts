const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api';

export async function apiCall<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const response = await fetch(`${API_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.statusText}`);
  }

  return response.json();
}

export async function submitKYC(data: {
  firstName: string;
  lastName: string;
  email: string;
  dateOfBirth: string;
  street: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
  documentType: string;
  walletAddress: string;
}) {
  return apiCall('/kyc/submit', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function getKYCStatus(walletAddress: string) {
  return apiCall(`/kyc/status?wallet=${walletAddress}`, {
    method: 'GET',
  });
}

export async function getUserProfile(walletAddress: string) {
  return apiCall(`/user/profile?wallet=${walletAddress}`, {
    method: 'GET',
  });
}

export async function getBalance(walletAddress: string) {
  return apiCall(`/balance?wallet=${walletAddress}`, {
    method: 'GET',
  });
}

export async function getTransactions(walletAddress: string, limit = 10) {
  return apiCall(`/transactions?wallet=${walletAddress}&limit=${limit}`, {
    method: 'GET',
  });
}
