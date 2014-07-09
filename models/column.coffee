module.exports = (sequelize, DataTypes) ->
  Column = sequelize.define 'Column', {
    elementSorting:
      type: DataTypes.ARRAY(DataTypes.INTEGER)
      allowNull: false
      defaultValue: '{}'
  }, {
    classMethods:
      associate: (models) ->
        Column.belongsTo models.Space
        Column.hasMany models.Element
  }
