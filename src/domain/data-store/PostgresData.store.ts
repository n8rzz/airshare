import * as pg from 'pg';
import { Sequelize } from 'sequelize';

export class PostgresDataStore {
  public db: Sequelize;

  public init(): void {
    this.db = new Sequelize(
      process.env.DB_NAME as string,
      process.env.DB_USER as string,
      process.env.DB_PASSWORD as string,
      {
        host: process.env.DB_HOST as string,
        dialect: 'postgres',
        dialectModule: pg,
      }
    );
  }

  public async authenticate(): Promise<void> {
    return this.db.authenticate();
  }
}
