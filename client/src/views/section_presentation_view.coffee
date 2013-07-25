window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.SectionPresentationView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['section.hbs']
  tagName: 'section'
  className: 'section-view'

  events:
    "click .add-narrative": "addNarrative"

  initialize: (options) ->
    @section = options.section

  render: =>
    @closeSubViews()
    @$el.html(@template(
      thisView: @
      section: @section.toJSON()
      visualisations: @section.get('visualisations').models
    ))
    @renderSubViews()

    return @

  addNarrative: =>
    @section.set('narrative', new Backbone.Models.Narrative())
    @render()

  onClose: ->
    @closeSubViews()
