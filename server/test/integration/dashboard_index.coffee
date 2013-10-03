assert = require('chai').assert
helpers = require '../helpers'
request = require('request')
cheerio = require('cheerio')
async = require('async')
url = require('url')
_ = require('underscore')


appurl = (path) ->
  url.resolve('http://localhost:3001', path)

# TODO: copyed from James's http://goo.gl/8Tu6tx
# Would be good to move in a more general helper.
createReportModels = (attributes) ->
  successCallback = errorCallback = promises = null

  Report = require('../../models/report').model
  createFunctions = _.map(attributes, (attributeSet) ->
    return (callback) ->
      report = new Report(attributeSet)
      return report.save( (err, indicators)->
        if err?
          callback()

        callback(null, indicators)
      )
  )

  async.parallel(
    createFunctions,
    (error, results) ->
      if error?
        errorCallback(error, results) if errorCallback?
      else
        successCallback(results) if successCallback?
  )

  promises = {
    success: (callback)->
      successCallback = callback
      return promises
    error: (callback)->
      errorCallback = callback
      return promises
  }
  return promises


suite('Dashboard')

test('GET index', (done) ->
  request.get appurl('/dashboard'), (err, res, body) ->
    assert.equal 200, res.statusCode
    done()
)

test('GET index has latest edited reports listed', (done) ->
  createReportModels([
    {
      title: 'Report 1'
      introduction: 'The intro for the first report'
    }, {
      title: 'Report 2'
      description: 'The intro for the second report'
    }
  ]).success((reports)->
    request.get appurl('/dashboard'), (err, res, body) ->
      $ = cheerio.load(body)
      reports_count = $('body').find("section.report-indicator-list").length
      assert.isTrue reports_count > 0, 'There is at least one report on the page'
      done()
  ).error((error) ->
    console.error error
    throw "Unable to create reports"
  )
)
