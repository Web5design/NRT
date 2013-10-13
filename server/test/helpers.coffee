passportStub = require 'passport-stub'
app = require('../app')
test_server = null
url = require('url')
mongoose = require('mongoose')
_ = require('underscore')
async = require('async')
Q = require('q')
factory = require('./factory')

Section = require('../models/section').model
Report = require('../models/report').model
Indicator = require('../models/indicator').model
IndicatorData = require('../models/indicator_data').model
Visualisation = require('../models/visualisation').model
Narrative = require('../models/narrative').model
Theme = require('../models/theme').model
Page = require('../models/page').model
User = require('../models/user').model
Permission = require('../models/permission').model

before( (done) ->
  expressApp = app.start 3001, (err, server) ->
    test_server = server
    done()
  passportStub.install expressApp
)

after( (done) ->
  test_server.close (err) ->
    if err?
      console.error err

    done()
)

afterEach( ->
  passportStub.logout()
)

dropDatabase = (connection, done) ->
  models = [
    Report,
    Indicator,
    IndicatorData,
    Narrative,
    Section,
    Visualisation,
    Theme,
    Page,
    User,
    Permission
  ]

  for model in models
    model
      .remove()
      .exec()

  done()

beforeEach( (done) ->
  connection = mongoose.connection
  state = connection.readyState

  if state == 2
    connection.on 'open', -> dropDatabase(connection, done)
  else if state == 1
    dropDatabase(connection, done)
)

exports.appurl = (path) ->
  url.resolve('http://localhost:3001', path)

exports.createReport = (attributes, callback) ->
  if arguments.length == 1
    callback = attributes
    attributes = undefined

  report = new Report(attributes || title: "new report")

  report.save (err, report) ->
    if err?
      throw 'could not save report'

    callback(report)

exports.createIndicator = (attributes, callback) ->
  if arguments.length == 1
    callback = attributes
    attributes = undefined

  indicator = new Indicator(attributes || title: "new indicator")

  indicator.save (err, indicator) ->
    if err?
      throw 'could not save indicator'

    callback(null, indicator)

exports.createIndicatorData = (attributes, callback) ->
  attributes.data ||= []

  IndicatorData.create(attributes, (error, results) ->
    if error?
      console.error error
      throw 'could not save indicator data'

    callback(error, results)
  )

exports.createVisualisation = (attributes, callback) ->
  if arguments.length == 1
    callback = attributes
    attributes = undefined

  visualisation = new Visualisation(attributes || data: "new visualisation")

  visualisation.save (err, Visualisation) ->
    if err?
      throw 'could not save visualisation'

    callback(null, visualisation)

exports.createNarrative = (attributes, callback) ->
  if arguments.length == 1
    callback = attributes
    attributes = undefined

  narrative = new Narrative(attributes || content: "new narrative")

  narrative.save (err, narrative) ->
    if err?
      throw 'could not save narrative'

    callback(null, narrative)

exports.createSection = (attributes, callback) ->
  if arguments.length == 1
    callback = attributes
    attributes = undefined

  section = new Section(attributes || content: "a section")

  section.save (err, section) ->
    if err?
      throw 'could not save section'

    callback(null, section)

exports.createIndicatorModels = factory.define("indicator", title: "new report")
exports.createReportModels = factory.define("report", title: "new report")
exports.createThemesFromAttributes = factory.define("theme", title: "new theme")

exports.createUser = factory.define("user",
  email: "hats@boats.com"
  password: "yomamalikeshats"
)

exports.createTheme = factory.define("theme", title: "new theme")
exports.createPage = factory.define("page", title: "new page")
