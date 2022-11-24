import type { NextApiRequest, NextApiResponse } from 'next';
import { PostgresDataStore } from '../../src/domain/data-store/PostgresData.store';

export enum DbStatus {
  Error = 'Error',
  Ok = 'Ok',
  Unknown = 'Unknown'
}

interface Data {
}

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Data>
) {
  let dbStatus = DbStatus.Unknown;

  try {
    const store = new PostgresDataStore();

    await store.init();
    await store.authenticate();

    dbStatus = DbStatus.Ok;
  } catch (error) {
    console.error(error);

    dbStatus = DbStatus.Error;
  }

  res.status(200).json({ app: 'ok', database: dbStatus });
}
