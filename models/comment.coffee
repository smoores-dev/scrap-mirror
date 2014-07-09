module.exports = (sequelize, DataTypes) ->
  Comment = sequelize.define 'Comment', {
    content:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    classMethods:
      associate: (models) ->
        Comment.belongsTo models.User, as: 'Creator', foreignKey: 'creator_id'
        Comment.belongsTo models.Element
  }
