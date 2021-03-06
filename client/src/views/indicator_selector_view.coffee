window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.IndicatorSelectorView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['indicator_selector.hbs']
  className: 'modal indicator-selector'

  events:
    "click .close": "close"

  initialize: (options = {}) ->
    @currentIndicator  = options.currentIndicator
    @indicators = new Backbone.Collections.IndicatorCollection([], withData: true)
    @indicators.fetch(
      success: @render
    )

  render: =>
    $('body').addClass('stop-scrolling')

    @$el.html(@template(
      thisView: @
      currentIndicator: @currentIndicator
      indicators: @indicators.groupByType()
    ))
    @attachSubViews()

    @bindToIndicatorSelection()

    return @

  bindToIndicatorSelection: ->
    for key, subView of @subViews
      @listenTo(subView, 'indicatorSelected', @triggerIndicatorSelected)

  triggerIndicatorSelected: (indicator) =>
    @trigger('indicatorSelected', indicator)

  onClose: ->
    $('body').removeClass('stop-scrolling')

    @stopListening()
    @closeSubViews()
