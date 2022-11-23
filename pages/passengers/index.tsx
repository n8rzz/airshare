import Head from 'next/head';
import React from 'react';
import { PassengersPage } from '../../src/components/page-components/passengers-page/PassengersPage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>Passengers | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'} />
      </Head>
      <PassengersPage />
    </React.Fragment>
  );
}
