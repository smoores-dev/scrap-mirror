module.exports = (sequelize, DataTypes) ->
  Space = sequelize.define 'Space', {
    name:
      type: DataTypes.TEXT
    spaceKey:
      type: DataTypes.TEXT
    lastChange:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
    columnSorting:
      type: DataTypes.ARRAY(DataTypes.INTEGER)
      allowNull: false
      defaultValue: '{}'
  }, {
    classMethods:
      associate: (models) ->
        Space.hasMany models.User, through: models.UserSpace
        Space.hasMany models.Element
  }
