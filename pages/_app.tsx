import "../styles/globals.css";
import type { AppProps } from "next/app";
import { SessionProvider } from "next-auth/react";
import { MantineProvider } from "@mantine/core";
import { AppHeader } from "../src/components/shared/app-header/AppHeader";
import { theme } from "../src/components/ui/theme/theme";

export default function App({
  Component,
  pageProps
}: AppProps) {
  return (
    <SessionProvider session={pageProps.session}>
      <MantineProvider
        withGlobalStyles={true}
        withNormalizeCSS={true}
        theme={theme}
      >
        <AppHeader />
        <Component {...pageProps} />
      </MantineProvider>
    </SessionProvider>
  );
}
