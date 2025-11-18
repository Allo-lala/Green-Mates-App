// src/components/ui/dialog.tsx
'use client';

import * as React from 'react';
import * as RadixDialog from '@radix-ui/react-dialog';

export const Dialog = RadixDialog.Root;
export const DialogTrigger = RadixDialog.Trigger;
export const DialogContent: React.FC<React.ComponentProps<typeof RadixDialog.Content>> = (props) => (
  <RadixDialog.Portal>
    <RadixDialog.Content {...props} className={`rounded-lg bg-white p-6 shadow-lg ${props.className}`} />
  </RadixDialog.Portal>
);
export const DialogHeader: React.FC<React.PropsWithChildren<{ className?: string }>> = ({ children, className }) => (
  <div className={`mb-4 ${className}`}>{children}</div>
);
export const DialogTitle: React.FC<React.PropsWithChildren<{ className?: string }>> = ({ children, className }) => (
  <RadixDialog.Title className={`text-lg font-bold ${className}`}>{children}</RadixDialog.Title>
);
export const DialogDescription: React.FC<React.PropsWithChildren<{ className?: string }>> = ({ children, className }) => (
  <RadixDialog.Description className={`text-sm text-muted-foreground ${className}`}>{children}</RadixDialog.Description>
);
export const DialogClose = RadixDialog.Close;
