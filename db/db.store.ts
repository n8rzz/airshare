import { Sequelize } from "sequelize";

const db = new Sequelize(
  process.env.DB_NAME as string,
  process.env.DB_USER as string,
  process.env.DB_PASSWORD as string,
  {
    host: process.env.DB_HOST as string,
    dialect: "postgres",
  }
);

export function connectToDatabase() {
  return db;
}
