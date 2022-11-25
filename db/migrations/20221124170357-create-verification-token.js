'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('verificationTokens', {
      token: { type: Sequelize.STRING(2000), primaryKey: true, unique: 'token' },
      identifier: { type: Sequelize.STRING, allowNull: false, unique: 'identifier' },
      expires: { type: Sequelize.DATE, allowNull: false },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('verificationTokens');
  },
};
