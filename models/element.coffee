module.exports = (sequelize, DataTypes) ->
  Element = sequelize.define 'Element', {
    contentType:
      type: DataTypes.ENUM 'text', 'image', 'website', 'data', 'video'
      allowNull: false
    content:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    classMethods:
      associate: (models) ->
        Element.belongsTo models.User, foreignKey: 'creatorId', as: 'Creator'
        Element.belongsTo models.Column
  }
