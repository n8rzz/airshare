import * as dotenv from 'dotenv';
import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import {NextApiRequest, NextApiResponse} from "next";

dotenv.config();

export const authOptions = {
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_ID as string,
      clientSecret: process.env.GOOGLE_SECRET as string
    }),
    // ...add more providers here
  ],
};

console.log('---', process.env);

const authHandler = (req: NextApiRequest, res: NextApiResponse) => NextAuth(req, res, authOptions);

export default authHandler;
