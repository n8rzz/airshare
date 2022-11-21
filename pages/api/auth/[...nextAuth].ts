import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import {NextApiRequest, NextApiResponse} from "next";

export const authOptions = {
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_ID as string,
      clientSecret: process.env.GOOGLE_SECRET as string
    }),
    // ...add more providers here
  ],
};

export default (req: NextApiRequest, res: NextApiResponse) => NextAuth(req, res, authOptions);
