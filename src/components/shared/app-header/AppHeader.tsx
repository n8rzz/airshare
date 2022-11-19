import Head from "next/head";
import Link from "next/link";
import React from "react";
import { Route } from "./AppHeader.constants";

interface IProps {}

export const AppHeader: React.FC<IProps> = (props) => {
  return (
    <React.Fragment>
      <Head>
        <title>Airshare.com</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <nav>
        <li>
          <Link href={Route.Home}>AirShare.com</Link>
        </li>
        <li>
          <Link href={Route.Flights}>Flights</Link>
        </li>
        <li>
          <Link href={Route.Passangers}>Passangers</Link>
        </li>
        <li>
          <Link href={Route.Schedule}>Schedule</Link>
        </li>
        <li>
          <Link href={Route.Login}>Login</Link>
        </li>
        <li>
          <Link href={Route.Register}>Register</Link>
        </li>
      </nav>
    </React.Fragment>
  );
};

AppHeader.displayName = "AppHeader";
