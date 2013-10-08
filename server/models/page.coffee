mongoose = require('mongoose')
Section = require('./section.coffee').schema
async = require('async')
_ = require('underscore')
sectionNestingModel = require('../mixins/section_nesting_model.coffee')
Q = require('q')

pageSchema = mongoose.Schema(
  title: String
  parent_id: mongoose.Schema.Types.ObjectId
  parent_type: String
  sections: [mongoose.Schema(
    title: String
    type: String
    indicator: {type: mongoose.Schema.Types.ObjectId, ref: 'Indicator'}
  )]
  is_draft: type: Boolean, default: false
)

_.extend(pageSchema.statics, sectionNestingModel)

pageSchema.methods.getParent = ->
  Ownable = require("./#{@parent_type.toLowerCase()}.coffee").model
  return Q.nsend(Ownable, 'findOne', @parent_id)

pageSchema.methods.createDraftClone = ->
  deferred = Q.defer()

  attributes = @
  delete attributes._id
  attributes.is_draft = true

  Q.nsend(
    Page, 'create', attributes
  ).then( (page) ->
    deferred.resolve(page)
  ).fail( (err) ->
    deferred.reject(err)
  )

  return deferred.promise

pageSchema.methods.getOwnable = ->
  @getParent()

pageSchema.methods.canBeEditedBy = (user) ->
  deferred = Q.defer()

  if user?
    deferred.resolve()
  else
    deferred.reject(new Error('Must be authenticated as a user to edit pages'))

  return deferred.promise

Page = mongoose.model('Page', pageSchema)

module.exports = {
  schema: pageSchema
  model: Page
}
