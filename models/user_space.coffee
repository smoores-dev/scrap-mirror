module.exports = (sequelize, DataTypes) ->
  UserSpace = sequelize.define 'UserSpace', {
    isActive: DataTypes.BOOLEAN
  }, {
    classMethods:
      associate: (models) ->
        UserSpace.belongsTo models.User
        UserSpace.belongsTo models.Space
  }
