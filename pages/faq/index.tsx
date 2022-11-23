import React from 'react';
import Head from 'next/head';
import { FaqPage } from '../../src/components/page-components/faq-page/FaqPage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>FAQ | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'}/>
      </Head>
      <FaqPage/>
    </React.Fragment>
  );
}
