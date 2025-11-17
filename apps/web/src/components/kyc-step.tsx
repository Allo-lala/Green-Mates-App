'use client';

interface KYCStepProps {
  title: string;
  fields: Array<{
    label: string;
    type: string;
    value: string;
    onChange: (value: string) => void;
  }>;
}

export default function KYCStep({ title, fields }: KYCStepProps) {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-semibold text-foreground">{title}</h2>
      {fields.map((field, index) => (
        <div key={index}>
          <label className="block text-sm font-medium text-foreground mb-2">
            {field.label}
          </label>
          <input
            type={field.type}
            value={field.value}
            onChange={(e) => field.onChange(e.target.value)}
            placeholder={field.label}
            className="w-full rounded-lg border border-muted bg-background px-4 py-3 text-foreground placeholder:text-muted-foreground focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 transition-all"
          />
        </div>
      ))}
    </div>
  );
}
