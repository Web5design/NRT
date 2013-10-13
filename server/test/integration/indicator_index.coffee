assert = require('chai').assert
helpers = require '../helpers'
request = require('request')
async = require('async')
url = require('url')
_ = require('underscore')

suite('Indicator index')

test("With a series of indicators, I should see their titles", (done) ->
  themeAttributes = [{
    title: 'Theme 1'
  },{
    title: 'Theme 2'
  }]

  helpers.createThemesFromAttributes(
    themeAttributes
  ).then( (themes) ->
    indicatorAttributes = [{
      title: "I am an indicator of theme 1"
      theme: themes[0]._id
    },{
      title: "theme 2 indicator"
      theme: themes[1]._id
    }]

    helpers.createIndicatorModels(
      indicatorAttributes
    ).then( (indicators)->
      request.get {
        url: helpers.appurl('/indicators')
      }, (err, res, body) ->
        assert.equal res.statusCode, 200

        for theme in themes
          assert.match body, new RegExp(".*#{theme.title}.*")

        for indicator in indicators
          assert.match body, new RegExp(".*#{indicator.title}.*")

        done()
    ).fail( (error) ->
      console.error error
      throw "Unable to create themes"
    )
  ).fail( (err) ->
    console.err err
  )
)
