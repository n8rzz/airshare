import Head from "next/head";
import { LoginPage } from "../../src/components/page-components/login-page/LoginPage";
import { AppHeader } from "../../src/components/shared/app-header/AppHeader";

export default function Home() {
  return (
    <div>
      <AppHeader />
      <LoginPage />
    </div>
  );
}
