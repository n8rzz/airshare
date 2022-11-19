import "../styles/globals.css";
import type { AppProps } from "next/app";
import { MantineProvider } from "@mantine/core";
import { AppHeader } from "../src/components/shared/app-header/AppHeader";
import { Route } from "../src/components/shared/app-header/AppHeader.constants";

export default function App({ Component, pageProps }: AppProps) {
  return (
    <MantineProvider
      withGlobalStyles={true}
      withNormalizeCSS={true}
      theme={{
        colorScheme: "light",
      }}
    >
      <AppHeader />
      <Component {...pageProps} />
    </MantineProvider>
  );
}
