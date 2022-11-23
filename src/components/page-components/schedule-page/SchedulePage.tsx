import React from 'react';
import { useSession } from 'next-auth/react';
import { AccessDenied } from '../../shared/access-denied/AccessDenied';

interface IProps {}

export const SchedulePage: React.FC<IProps> = (props) => {
  const { data: session } = useSession();

  if (!session) {
    return <AccessDenied />;
  }

  return <h2>SchedulePage</h2>;
};

SchedulePage.displayName = 'SchedulePage';
