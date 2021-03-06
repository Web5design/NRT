window.Helpers ||= {}

Helpers.renderViewToTestContainer = (view) ->
  view.render()
  $('#test-container').html(view.el)

window.Helpers.SinonServer ||= {}

Helpers.assertCalledOnce = (sinonObj) ->
  assert.ok(
    sinonObj.calledOnce,
    "Expected spy/stub to be called once but was called
      #{sinonObj.callCount} times"
  )

Helpers.viewHasSubViewOfClass = (view, subViewClassName) ->
  subViewExists = false
  for subViewKey, subView of view.subViews
    if subView.constructor.name == subViewClassName
      subViewExists = true
  return subViewExists

# Used to extend Sinon Servers with common response method
Helpers.SinonServer.respondWithJson = (jsonData) ->
  @requests[0].respond(
    200,
    { "Content-Type": "application/json" },
    JSON.stringify(jsonData)
  )

window.Factory ||= {}

Factory.findNextFreeId = (modelName) ->
  Factory.modelIds ||= {}
  Factory.modelIds[modelName] ||= 0

  while Backbone.Models[modelName].findOrCreate(Factory.modelIds[modelName])?
    Factory.modelIds[modelName] = Factory.modelIds[modelName] + 1

  return Factory.modelIds[modelName]

Factory.page = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('Page')
  new Backbone.Models.Page(
    attributes
  )

Factory.user = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('User')
  new Backbone.Models.User(
    attributes
  )

Factory.report = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('Report')
  new Backbone.Models.Report(
    attributes
  )

Factory.indicator = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('Indicator')
  attributes.indicatorDefinition ||=
    fields: []
  new Backbone.Models.Indicator(
    attributes
  )

Factory.theme = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('Theme')
  new Backbone.Models.Theme(
    attributes
  )

Factory.section = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('Section')
  attributes.indicator ||= Factory.indicator()
  new Backbone.Models.Section(
    attributes
  )

Factory.visualisation = (attributes = {}) ->
  attributes._id ||= Factory.findNextFreeId('Visualisation')
  attributes.indicator ||= Factory.indicator()
  unless attributes.hasOwnProperty? 'data'
    attributes.data =
      results: []
      bounds: {}

  new Backbone.Models.Visualisation(attributes)

