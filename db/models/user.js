/* eslint-disable @typescript-eslint/no-var-requires */
'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      this.belongsTo(models.Account);
      this.belongsTo(models.Session);
    }
  }

  User.init(
    {
      id: DataTypes.UUID,
    },
    {
      sequelize,
      modelName: 'User',
    }
  );

  return User;
};
