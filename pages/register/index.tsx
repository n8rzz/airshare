import React from 'react';
import Head from 'next/head';
import { RegisterPage } from '../../src/components/page-components/register-page/RegisterPage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>Register | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'} />
      </Head>
      <RegisterPage />
    </React.Fragment>
  );
}
