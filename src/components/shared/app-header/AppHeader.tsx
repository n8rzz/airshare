import Head from "next/head";
import Link from "next/link";
import React from "react";
import { Route } from "./AppHeader.constants";
import { Navigation } from "./navigation/Navigation";

interface IProps {}

export const AppHeader: React.FC<IProps> = (props) => {
  return (
    <React.Fragment>
      <Head>
        <title>Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Navigation />
    </React.Fragment>
  );
};

AppHeader.displayName = "AppHeader";
