import React from 'react';
import { getSession } from 'next-auth/react';
import { NextPageContext } from 'next';
import { Session } from 'next-auth';
import { AccessDenied } from '../../shared/access-denied/AccessDenied';

interface IProps {
  session: Session | null;
}

export const PassengersPage: React.FC<IProps> = (props) => {
  if (!props.session) {
    return <AccessDenied/>;
  }

  return <h2>PassengersPage</h2>;
};

export async function getServerSideProps(context: NextPageContext) {
  const session = await getSession(context)

  return {
    props: {
      session
    }
  }
}

PassengersPage.displayName = 'PassengersPage';
