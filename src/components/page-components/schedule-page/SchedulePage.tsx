import React from 'react';
import { getSession } from 'next-auth/react';
import { AccessDenied } from '../../shared/access-denied/AccessDenied';
import { NextPageContext } from 'next';
import { Session } from 'next-auth';

interface IProps {
  session: Session | null;
}

export const SchedulePage: React.FC<IProps> = (props) => {
  if (!props.session) {
    return <AccessDenied/>;
  }

  return <h2>SchedulePage</h2>;
};

export async function getServerSideProps(context: NextPageContext) {
  const session = await getSession(context)

  return {
    props: {
      session
    }
  }
}

SchedulePage.displayName = 'SchedulePage';
