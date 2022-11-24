'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Sessions', {
      id: {
        type: Sequelize.UUID,
        allowNull: false,
        autoIncrement: false,
        defaultValue: Sequelize.literal('gen_random_uuid()'),
        unique: true,
        primaryKey: true,
      },
      expires: {
        type: Sequelize.DATE,
      },
      sessionToken: {
        type: Sequelize.STRING(1000),
      },
      userId: {
        type: Sequelize.STRING(1000),
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
    await queryInterface.dropTable('Sessions');
  },
};
