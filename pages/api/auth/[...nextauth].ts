import * as dotenv from 'dotenv';
import { NextApiRequest, NextApiResponse } from 'next';
import NextAuth from 'next-auth';
import GoogleProvider from 'next-auth/providers/google';
import SequelizeAdapter from '@next-auth/sequelize-adapter';
import { PostgresDataStore } from '../../../src/domain/data-store/PostgresData.store';

dotenv.config();

const authHandler = async (req: NextApiRequest, res: NextApiResponse) => {
  const store = new PostgresDataStore();

  await store.init();

  const authOptions = {
    adapter: SequelizeAdapter(store.db, { synchronize: false }),
    providers: [
      GoogleProvider({
        clientId: process.env.GOOGLE_ID as string,
        clientSecret: process.env.GOOGLE_SECRET as string,
      }),
    ],
    debug: process.env.AUTH_DEBUG as unknown as boolean,
  };

  return NextAuth(req, res, authOptions);
};

export default authHandler;
