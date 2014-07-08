module.exports = (sequelize, DataTypes) ->
  User = sequelize.define 'User', {
    fbId:
      type: DataTypes.INTEGER
      unique: true
    email:
      type: DataTypes.TEXT
      unique: true
      validate:
        isEmail: true
    name: DataTypes.TEXT
  }, {
    classMethods:
      associate: (models) ->
        User.hasMany models.Space, through: models.UserSpace
  }
