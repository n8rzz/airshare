import React from 'react';
import Head from 'next/head';
import { FlightsPage } from '../../src/components/page-components/flights-page/FlightsPage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>Flights | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'}/>
      </Head>
      <FlightsPage/>
    </React.Fragment>
  );
}
