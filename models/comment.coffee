module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Comment', {
    creation_time:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
    content:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    classMethods:
      associate: (models) ->
        Comment.hasMany models.User, as: 'Creator'
        Comment.hasMany models.Element
  }
