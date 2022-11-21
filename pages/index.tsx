import Head from "next/head";
import React from "react";
import { useSession } from "next-auth/react";
import { LandingPage } from "../src/components/page-components/landing-page/LandingPage";

export default function Home() {
  const [session, loading] = useSession();

  console.log('session: ', session)

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
