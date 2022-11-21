import Head from "next/head";
import React from "react";
import { LandingPage } from "../src/components/page-components/landing-page/LandingPage";

export default function Home() {
  return (
    <>
      <Head>
        <title>Home | Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <LandingPage />
    </>
  );
}
