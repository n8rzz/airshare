import type { NextApiRequest, NextApiResponse } from "next";
import { Sequelize } from "sequelize";
import { connectToDatabase } from "../../db/db.store";

interface Data {}

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Data>
) {
  let dbStatus = "unknown";

  try {
    const db = connectToDatabase();

    await db.authenticate();

    dbStatus = "ok";
  } catch (e) {
    dbStatus = "error";
  }

  res.status(200).json({ app: "ok", database: dbStatus });
}
