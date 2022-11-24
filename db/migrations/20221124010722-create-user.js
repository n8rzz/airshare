'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Users', {
      id: {
        type: Sequelize.UUID,
        allowNull: false,
        autoIncrement: false,
        defaultValue: Sequelize.literal('gen_random_uuid()'),
        unique: true,
        primaryKey: true,
      },
      userId: {
        type: Sequelize.STRING,
      },
      type: {
        type: Sequelize.STRING,
      },
      provider: {
        type: Sequelize.STRING,
      },
      providerAccountId: {
        type: Sequelize.STRING,
      },
      refresh_token: {
        type: Sequelize.STRING(1000)
      },
      access_token: {
        type: Sequelize.STRING(1000)
      },
      expires_at: {
        type: Sequelize.INTEGER,
      },
      token_type: {
        type: Sequelize.STRING,
      },
      scope: {
        type: Sequelize.STRING,
      },
      id_token: {
        type: Sequelize.STRING,
      },
      session_state: {
        type: Sequelize.STRING,
      },
      oauth_token_secret: {
        type: Sequelize.STRING(1000)
      },
      oauth_token: {
        type: Sequelize.STRING(1000)
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
    await queryInterface.dropTable('Users');
  },
};
