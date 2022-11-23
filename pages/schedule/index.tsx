import Head from 'next/head';
import React from 'react';
import { SchedulePage } from '../../src/components/page-components/schedule-page/SchedulePage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>Schedule | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'} />
      </Head>
      <SchedulePage />
    </React.Fragment>
  );
}
