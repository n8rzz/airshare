'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('accounts', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },
      type: { type: Sequelize.STRING, allowNull: false },
      provider: { type: Sequelize.STRING, allowNull: false },
      provider_account_id: { type: Sequelize.STRING, allowNull: false },
      refresh_token: { type: Sequelize.STRING },
      access_token: { type: Sequelize.STRING(2000) },
      expires_at: { type: Sequelize.INTEGER },
      token_type: { type: Sequelize.STRING },
      scope: { type: Sequelize.STRING },
      id_token: { type: Sequelize.STRING(2000) },
      session_state: { type: Sequelize.STRING },
      oauth_token_secret: { type: Sequelize.STRING(2000) },
      oauth_token: { type: Sequelize.STRING(2000) }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('accounts');
  },
};
