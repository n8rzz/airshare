import Head from "next/head";
import React from "react";
import { PassengersPage } from "../../src/components/page-components/passangers-page/PassangersPage";

export default function Home() {
  return (
    <>
      <Head>
        <title>Passengers | Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <PassengersPage />
    </>
  );
}
