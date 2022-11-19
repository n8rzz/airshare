import Head from "next/head";
import { FaqPage } from "../../src/components/page-components/faq-page/FaqPage";
import { FlightsPage } from "../../src/components/page-components/flights-page/FlightsPage";
import { AppHeader } from "../../src/components/shared/app-header/AppHeader";

export default function Home() {
  return (
    <>
      <Head>
        <title>FAQ | Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <FaqPage />
    </>
  );
}
