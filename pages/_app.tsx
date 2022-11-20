import "../styles/globals.css";
import type { AppProps } from "next/app";
import { MantineProvider } from "@mantine/core";
import { AppHeader } from "../src/components/shared/app-header/AppHeader";
import { Route } from "../src/components/shared/app-header/AppHeader.constants";
import { theme } from "../src/components/ui/theme/theme";

export default function App({ Component, pageProps }: AppProps) {
  return (
    <MantineProvider
      withGlobalStyles={true}
      withNormalizeCSS={true}
      theme={theme}
    >
      <AppHeader />
      <Component {...pageProps} />
    </MantineProvider>
  );
}
