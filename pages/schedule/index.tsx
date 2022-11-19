import Head from "next/head";
import React from "react";
import { SchedulePage } from "../../src/components/page-components/schedule-page/SchedulePage";

export default function Home() {
  return (
    <>
      <Head>
        <title>Schedule | Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <SchedulePage />
    </>
  );
}
