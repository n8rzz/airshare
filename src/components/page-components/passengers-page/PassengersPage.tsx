import React from 'react';
import { getSession, useSession } from 'next-auth/react';
import { AccessDenied } from '../../shared/access-denied/AccessDenied';

interface IProps {
  session: unknown;
}

export const PassengersPage: React.FC<IProps> = (props) => {
  const { data: session } = useSession();

  if (!session) {
    return <AccessDenied/>;
  }

  return <h2>PassengersPage</h2>;
};

export async function getServerSideProps(context) {
  const session = await getSession(context)

  return {
    props: {
      session
    }
  }
}

PassengersPage.displayName = 'PassengersPage';
