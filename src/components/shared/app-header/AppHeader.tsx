import Head from 'next/head';
import React from 'react';
import { Navigation } from './navigation/Navigation';

interface IProps {}

export const AppHeader: React.FC<IProps> = (props) => {
  return (
    <React.Fragment>
      <Head>
        <title>Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'} />
      </Head>

      <Navigation />
    </React.Fragment>
  );
};

AppHeader.displayName = 'AppHeader';
