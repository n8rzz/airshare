'use strict';
const {
  Model
} = require('sequelize');


module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }

  User.init({
    id: DataTypes.STRING,
    userId: DataTypes.STRING,
    type: DataTypes.STRING,
    provider: DataTypes.STRING,
    providerAccountId: DataTypes.STRING,
    refresh_token: DataTypes.STRING,
    access_token: DataTypes.STRING,
    expires_at: DataTypes.INTEGER,
    token_type: DataTypes.STRING,
    scope: DataTypes.STRING,
    id_token: DataTypes.STRING,
    session_state: DataTypes.STRING,
    oauth_token_secret: DataTypes.STRING,
    oauth_token: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'User',
  });

  return User;
};
