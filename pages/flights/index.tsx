import Head from "next/head";
import { FlightsPage } from "../../src/components/page-components/flights-page/FlightsPage";
import { AppHeader } from "../../src/components/shared/app-header/AppHeader";

export default function Home() {
  return (
    <>
      <Head>
        <title>Flights | Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <FlightsPage />
    </>
  );
}
