'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('VerificationTokens', {
      id: {
        type: Sequelize.UUID,
        allowNull: false,
        autoIncrement: false,
        defaultValue: Sequelize.literal('gen_random_uuid()'),
        unique: true,
        primaryKey: true,
      },
      identifier: {
        type: Sequelize.STRING,
      },
      token: {
        type: Sequelize.STRING,
      },
      expires: {
        type: Sequelize.DATE,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('VerificationTokens');
  },
};
