module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Column', {
    creation_time:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
    element_sorting:
      type: DataTypes.ARRAY(DataTypes.INTEGER)
      allowNull: false
      defaultValue: []
  }, {
    classMethods:
      associate: (models) ->
        Column.hasOne models.Space
        Column.hasMany models.Element
  }
