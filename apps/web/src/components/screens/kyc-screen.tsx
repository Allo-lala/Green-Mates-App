'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { ChevronRight, Upload } from 'lucide-react';
import KYCStep from '@/components/kyc-step';

type KYCStep = 'personal' | 'address' | 'documents';

interface KYCData {
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
  documentFile: File | null;
}

const initialData: KYCData = {
  firstName: '',
  lastName: '',
  email: '',
  dateOfBirth: '',
  street: '',
  city: '',
  state: '',
  zipCode: '',
  country: '',
  documentType: 'passport',
  documentFile: null,
};

export default function KYCScreenComponent() {
  const router = useRouter();
  const [currentStep, setCurrentStep] = useState<KYCStep>('personal');
  const [kycData, setKYCData] = useState<KYCData>(initialData);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const steps: KYCStep[] = ['personal', 'address', 'documents'];
  const currentStepIndex = steps.indexOf(currentStep);

  const handleInputChange = (field: keyof KYCData, value: string | File | null) => {
    setKYCData(prev => ({
      ...prev,
      [field]: value,
    }));
    setError(null);
  };

  const validateCurrentStep = (): boolean => {
    if (currentStep === 'personal') {
      if (!kycData.firstName || !kycData.lastName || !kycData.email || !kycData.dateOfBirth) {
        setError('Please fill in all personal information fields');
        return false;
      }
    } else if (currentStep === 'address') {
      if (!kycData.street || !kycData.city || !kycData.state || !kycData.zipCode || !kycData.country) {
        setError('Please fill in all address fields');
        return false;
      }
    } else if (currentStep === 'documents') {
      if (!kycData.documentFile) {
        setError('Please upload a document');
        return false;
      }
    }
    return true;
  };

  const handleNext = () => {
    if (!validateCurrentStep()) return;

    if (currentStepIndex < steps.length - 1) {
      setCurrentStep(steps[currentStepIndex + 1]);
    } else {
      handleSubmit();
    }
  };

  const handlePrevious = () => {
    if (currentStepIndex > 0) {
      setCurrentStep(steps[currentStepIndex - 1]);
    }
  };

  const handleSubmit = async () => {
    setIsSubmitting(true);
    try {
      // Here you would send the KYC data to your backend
      await new Promise(resolve => setTimeout(resolve, 2000));
      router.push('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Submission failed');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted px-4 py-8">
      <div className="mx-auto max-w-2xl">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-2">
            Verify Your Identity
          </h1>
          <p className="text-muted-foreground">
            Complete KYC to unlock all GreenMates features
          </p>
        </div>

        {/* Progress indicator */}
        <div className="mb-8 flex gap-4">
          {steps.map((step, index) => (
            <div key={step} className="flex items-center gap-4">
              <div
                className={`flex h-10 w-10 items-center justify-center rounded-full font-semibold transition-all ${
                  index <= currentStepIndex
                    ? 'bg-primary text-white'
                    : 'bg-muted text-muted-foreground'
                }`}
              >
                {index + 1}
              </div>
              {index < steps.length - 1 && (
                <div
                  className={`flex-1 h-1 rounded-full transition-all ${
                    index < currentStepIndex ? 'bg-primary' : 'bg-muted'
                  }`}
                />
              )}
            </div>
          ))}
        </div>

        {/* Error message */}
        {error && (
          <div className="mb-6 rounded-lg border border-red-300 bg-red-50 p-4 text-red-700">
            {error}
          </div>
        )}

        {/* Step content */}
        <div className="space-y-6 mb-8">
          {currentStep === 'personal' && (
            <KYCStep
              title="Personal Information"
              fields={[
                {
                  label: 'First Name',
                  type: 'text',
                  value: kycData.firstName,
                  onChange: (value) => handleInputChange('firstName', value),
                },
                {
                  label: 'Last Name',
                  type: 'text',
                  value: kycData.lastName,
                  onChange: (value) => handleInputChange('lastName', value),
                },
                {
                  label: 'Email',
                  type: 'email',
                  value: kycData.email,
                  onChange: (value) => handleInputChange('email', value),
                },
                {
                  label: 'Date of Birth',
                  type: 'date',
                  value: kycData.dateOfBirth,
                  onChange: (value) => handleInputChange('dateOfBirth', value),
                },
              ]}
            />
          )}

          {currentStep === 'address' && (
            <KYCStep
              title="Address Information"
              fields={[
                {
                  label: 'Street Address',
                  type: 'text',
                  value: kycData.street,
                  onChange: (value) => handleInputChange('street', value),
                },
                {
                  label: 'City',
                  type: 'text',
                  value: kycData.city,
                  onChange: (value) => handleInputChange('city', value),
                },
                {
                  label: 'State/Province',
                  type: 'text',
                  value: kycData.state,
                  onChange: (value) => handleInputChange('state', value),
                },
                {
                  label: 'ZIP/Postal Code',
                  type: 'text',
                  value: kycData.zipCode,
                  onChange: (value) => handleInputChange('zipCode', value),
                },
                {
                  label: 'Country',
                  type: 'text',
                  value: kycData.country,
                  onChange: (value) => handleInputChange('country', value),
                },
              ]}
            />
          )}

          {currentStep === 'documents' && (
            <div className="space-y-4">
              <h2 className="text-xl font-semibold text-foreground">Upload Document</h2>
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Document Type
                </label>
                <select
                  value={kycData.documentType}
                  onChange={(e) => handleInputChange('documentType', e.target.value)}
                  className="w-full rounded-lg border border-muted bg-background px-4 py-3 text-foreground focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 transition-all"
                >
                  <option value="passport">Passport</option>
                  <option value="license">Driver's License</option>
                  <option value="id">National ID</option>
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Upload File
                </label>
                <div className="rounded-lg border-2 border-dashed border-primary/30 bg-primary/5 p-8 text-center hover:border-primary/50 transition-all">
                  <input
                    type="file"
                    accept="image/*,.pdf"
                    onChange={(e) => handleInputChange('documentFile', e.target.files?.[0] || null)}
                    className="hidden"
                    id="document-upload"
                  />
                  <label htmlFor="document-upload" className="cursor-pointer space-y-2">
                    <Upload className="mx-auto h-8 w-8 text-primary" />
                    <p className="font-medium text-foreground">
                      {kycData.documentFile ? kycData.documentFile.name : 'Click to upload'}
                    </p>
                    <p className="text-sm text-muted-foreground">
                      PNG, JPG, or PDF up to 10MB
                    </p>
                  </label>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Navigation buttons */}
        <div className="flex gap-3">
          <button
            onClick={handlePrevious}
            disabled={currentStepIndex === 0}
            className="flex-1 rounded-lg border border-muted bg-background py-3 font-medium text-foreground hover:bg-muted disabled:opacity-50 transition-all"
          >
            Back
          </button>
          <button
            onClick={handleNext}
            disabled={isSubmitting}
            className="flex-1 rounded-lg bg-gradient-to-r from-primary to-primary-light py-3 font-medium text-white hover:shadow-lg hover:shadow-primary/50 disabled:opacity-50 transition-all flex items-center justify-center gap-2"
          >
            {isSubmitting ? (
              <>
                <div className="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                Submitting...
              </>
            ) : currentStepIndex === steps.length - 1 ? (
              'Complete KYC'
            ) : (
              <>
                Next <ChevronRight className="h-4 w-4" />
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
