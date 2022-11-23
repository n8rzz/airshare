import React from 'react';
import { signIn } from 'next-auth/react';
import Link from 'next/link';

interface IProps {
}

export const AccessDenied: React.FC<IProps> = (props) => {
  return (
    <React.Fragment>
      <h1>Access Denied</h1>
      <p>
        <Link
          href={'/api/auth/signin'}
          onClick={(event) => {
            event.preventDefault();
            signIn();
          }}
        >
          You must be signed in to view this page
        </Link>
      </p>
    </React.Fragment>
  );
};

AccessDenied.displayName = 'AccessDenied';
