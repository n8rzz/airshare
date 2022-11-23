import Head from 'next/head';
import React from 'react';
import { LandingPage } from '../src/components/page-components/landing-page/LandingPage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>Home | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'} />
      </Head>
      <LandingPage />
    </React.Fragment>
  );
}
