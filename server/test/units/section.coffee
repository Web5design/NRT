assert = require('chai').assert
helpers = require '../helpers'
_ = require('underscore')

suite('Section')
test('.create', (done) ->
  Section = require('../../models/section').model

  section = new Section(title: 'Head Garments and Sea Vessels')
  section.save (err, section) ->
    if err?
      throw 'Section saving failed'

    Section.count (err, count) ->
      if err?
        throw err
        throw 'Failed to find Section'

      assert.equal 1, count
      done()
)

test('.getValidationErrors should return 0 errors if attributes have an indicator id', ->
  Section = require('../../models/section').model
  errors = Section.getValidationErrors(
    indicator: 5
  )
  assert.lengthOf errors, 0
)