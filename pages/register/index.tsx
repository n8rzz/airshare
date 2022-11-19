import React from "react";
import Head from "next/head";
import { RegisterPage } from "../../src/components/page-components/register-page/RegisterPage";

export default function Home() {
  return (
    <>
      <Head>
        <title>Register | Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <RegisterPage />
    </>
  );
}
