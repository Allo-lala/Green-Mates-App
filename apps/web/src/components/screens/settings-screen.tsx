'use client';

import { useState } from 'react';
import { Moon, Sun, Bell, Lock, HelpCircle, FileText } from 'lucide-react';
import { useTheme } from 'next-themes';

export default function SettingsScreen() {
  const { theme, setTheme } = useTheme();
  const [notifications, setNotifications] = useState(true);
  const [biometric, setBiometric] = useState(false);

  const settings = [
    {
      icon: Bell,
      title: 'Notifications',
      description: 'Manage notification preferences',
      value: notifications,
      onChange: setNotifications,
      type: 'toggle',
    },
    {
      icon: Lock,
      title: 'Biometric Security',
      description: 'Enable fingerprint or face ID',
      value: biometric,
      onChange: setBiometric,
      type: 'toggle',
    },
    {
      icon: Moon,
      title: 'Theme',
      description: `Current: ${theme === 'dark' ? 'Dark' : 'Light'} mode`,
      onClick: () => setTheme(theme === 'dark' ? 'light' : 'dark'),
      type: 'action',
    },
    {
      icon: HelpCircle,
      title: 'Help & Support',
      description: 'Get help and contact support',
      type: 'link',
      href: '#',
    },
    {
      icon: FileText,
      title: 'Terms & Privacy',
      description: 'Read our terms and privacy policy',
      type: 'link',
      href: '#',
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted pb-20">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary/10 to-accent/10 px-4 py-8">
        <div className="mx-auto max-w-2xl">
          <h1 className="text-3xl font-bold text-foreground">Settings</h1>
        </div>
      </div>

      {/* Settings */}
      <div className="mx-auto max-w-2xl space-y-4 px-4 py-8">
        {settings.map((setting, index) => {
          const Icon = setting.icon;
          return (
            <button
              key={index}
              onClick={setting.onClick}
              className="flex w-full items-center justify-between rounded-lg border border-muted bg-background p-4 hover:border-primary/30 hover:bg-muted/50 transition-all"
            >
              <div className="flex items-center gap-4 text-left">
                <div className="rounded-lg bg-primary/10 p-3">
                  <Icon className="h-5 w-5 text-primary" />
                </div>
                <div>
                  <p className="font-semibold text-foreground">{setting.title}</p>
                  <p className="text-sm text-muted-foreground">{setting.description}</p>
                </div>
              </div>

              {setting.type === 'toggle' && (
                <button
                  onClick={(e) => {
                    e.preventDefault();
                    setting.onChange?.(!setting.value);
                  }}
                  className={`relative h-6 w-11 rounded-full transition-colors ${
                    setting.value ? 'bg-primary' : 'bg-muted'
                  }`}
                >
                  <div
                    className={`absolute top-0.5 h-5 w-5 rounded-full bg-white transition-transform ${
                      setting.value ? 'translate-x-5' : 'translate-x-0.5'
                    }`}
                  />
                </button>
              )}

              {setting.type === 'action' && (
                <div className="text-right">
                  <Sun className="h-5 w-5 text-muted-foreground" />
                </div>
              )}

              {setting.type === 'link' && (
                <div className="text-right">
                  <div className="h-5 w-5 rounded-full border border-muted-foreground" />
                </div>
              )}
            </button>
          );
        })}
      </div>

      {/* App info */}
      <div className="mx-auto max-w-2xl px-4 py-8 text-center">
        <p className="text-sm text-muted-foreground">
          Grin Mates v0.1.0
        </p>
        <p className="mt-2 text-xs text-muted-foreground">
          Built on Celo for a sustainable future
        </p>
      </div>
    </div>
  );
}
