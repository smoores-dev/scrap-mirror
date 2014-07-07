module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Space', {
    name: DataTypes.TEXT
    creation_time:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
    last_change:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
    column_sorting:
      type: DataTypes.ARRAY(DataTypes.INTEGER)
      allowNull: false
      defaultValue: '{}'
  }, {
    classMethods:
      associate: (models) ->
        Space.hasMany models.User, through: models.UserSpace
        Space.hasMany models.Column
  }
