// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from "next";
import { db } from "../../db/connectToDb";

interface Data {}

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<Data>
) {
  console.log("Database Status", db.status());

  res.status(200).json({ name: "John Doe" });
}
