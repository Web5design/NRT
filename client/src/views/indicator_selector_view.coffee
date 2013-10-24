window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.IndicatorSelectorView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['indicator_selector.hbs']
  className: 'modal indicator-selector'

  events:
    "click .close": "close"

  initialize: (options) ->
    @section = options.section

    @indicators = new Backbone.Collections.IndicatorCollection()
    @indicators.fetch(
      success: @render
    )

  render: =>
    $('body').addClass('stop-scrolling')

    @closeSubViews()
    @$el.html(@template(
      thisView: @
      indicators: @indicators.groupByType()
      section: @section
    ))
    @renderSubViews()

    @bindToIndicatorSelection()

    return @

  bindToIndicatorSelection: ->
    for subView in @subViews
      @listenTo(subView, 'indicatorSelected', @close)

  onClose: ->
    $('body').removeClass('stop-scrolling')

    @stopListening()
    @closeSubViews()
