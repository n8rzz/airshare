import React from 'react';
import Head from 'next/head';
import { LoginPage } from '../../src/components/page-components/login-page/LoginPage';

export default function Home() {
  return (
    <React.Fragment>
      <Head>
        <title>Login | Airshare.com</title>
        <link href={'/favicon.ico'} rel={'icon'}/>
      </Head>
      <LoginPage/>
    </React.Fragment>
  );
}
