module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Element', {
    creation_time:
      type: DataTypes.DATE
      allowNull: false
      defaultValue: DataTypes.NOW
    content_type:
      type: DataTypes.ENUM 'text', 'image', 'website', 'data'
      allowNull: false
    content:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    classMethods:
      associate: (models) ->
        Element.hasOne models.User, foreignKey: 'creator_id'
        Element.hasMany models.Column
  }
