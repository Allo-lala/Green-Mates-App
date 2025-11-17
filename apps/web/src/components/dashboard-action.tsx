'use client';

import { type LucideIcon } from 'lucide-react';

interface DashboardActionProps {
  icon: LucideIcon;
  label: string;
  color: string;
}

export default function DashboardAction({
  icon: Icon,
  label,
  color,
}: DashboardActionProps) {
  return (
    <button className="group relative overflow-hidden rounded-xl p-6 transition-all hover:shadow-lg">
      {/* Gradient background */}
      <div className={`absolute inset-0 bg-gradient-to-br ${color} opacity-10 group-hover:opacity-20 transition-all`} />
      
      {/* Border */}
      <div className="absolute inset-0 rounded-xl border border-transparent group-hover:border-primary/20 transition-all" />

      {/* Content */}
      <div className="relative space-y-3 text-center">
        <div className={`mx-auto rounded-lg bg-gradient-to-br ${color} p-3 w-fit`}>
          <Icon className="h-6 w-6 text-white" />
        </div>
        <p className="font-semibold text-foreground text-sm">{label}</p>
      </div>
    </button>
  );
}
