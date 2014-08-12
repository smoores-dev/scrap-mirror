module.exports = (sequelize, DataTypes) ->
  Space = sequelize.define 'Space', {
    name:
      type: DataTypes.TEXT
      allowNull: false
    spaceKey:
      type: DataTypes.TEXT
      allowNull: false
    lastChange:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
  }, {
    classMethods:
      associate: (models) ->
        Space.hasMany models.User
        Space.hasMany models.Element
  }
