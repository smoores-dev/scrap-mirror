module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Comment',
    is_active: DataTypes.BOOLEAN
