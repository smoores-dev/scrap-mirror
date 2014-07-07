module.exports = (sequelize, DataTypes) ->
  sequelize.define 'User', {
    fb_id:
      type: DataTypes.INTEGER
      unique: true
    email:
      type: DataTypes.TEXT
      unique: true
    name: DataTypes.TEXT
  }, {
    classMethods:
      associate: (models) ->
        User.hasMany models.Space, through: models.UserSpace
  }
