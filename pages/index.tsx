import Head from "next/head";
import { LandingPage } from "../src/components/page-components/landing-page/LandingPage";
import { AppHeader } from "../src/components/shared/app-header/AppHeader";

export default function Home() {
  return (
    <div>
      <Head>
        <title>Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <AppHeader />
      <LandingPage />
    </div>
  );
}
