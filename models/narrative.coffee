Sequelize = require("sequelize-mysql").sequelize

Narrative = sequelize.define('Narrative', {

  # instantiating will automatically set the flag to true if not set
  flag: { type: Sequelize.BOOLEAN, allowNull: false, defaultValue: true},

  # default values for dates => current time
  myDate: { type: Sequelize.DATE, defaultValue: Sequelize.NOW },

  # setting allowNull to false will add NOT NULL to the column, which means an
  #  error will be
  # thrown from the DB when the query is executed if the column is null. If 
  #  you want to check that a value
  # is not null before querying the DB, look at the validations section below.
  title: { type: Sequelize.STRING, allowNull: false},

  content: { type: Sequelize.STRING, allowNull: false},

  # Creating two objects with the same value will throw an error. Currently 
  #  composite unique
  # keys can only be created 'addIndex' from the migration-section below
  ##someUnique: {type: Sequelize.STRING, unique: true},
  # Go on reading for further information about primary keys

  id: { type: Sequelize.STRING, primaryKey: true},

})

Narrative.sync()

module.exports = Narrative
