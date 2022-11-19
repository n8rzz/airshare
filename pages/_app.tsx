import "../styles/globals.css";
import type { AppProps } from "next/app";
import { MantineProvider } from "@mantine/core";
import { AppHeader } from "../src/components/shared/app-header/AppHeader";
import { AppFooter } from "../src/components/shared/app-footer/AppFooter";
import { Route } from "../src/components/shared/app-header/AppHeader.constants";

export const footerLinkList = [
  {
    title: "Product",
    links: [
      {
        label: "Pricing",
        link: Route.Home,
      },
      {
        label: "Why?",
        link: Route.Home,
      },
    ],
  },
  {
    title: "Docs",
    links: [
      {
        label: "FAQ",
        link: Route.Faq,
      },
    ],
  },
  {
    title: "Legal",
    links: [
      {
        label: "Privacy Policy",
        link: Route.Home,
      },
      {
        label: "Security Policy",
        link: Route.Home,
      },
    ],
  },
];

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
      <AppFooter data={footerLinkList} />
    </MantineProvider>
  );
}
