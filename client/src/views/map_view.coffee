window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.MapView extends Backbone.View
  template: Handlebars.templates['map.hbs']
  className: 'map-view'

  initialize: (options) ->
    @visualisation = options.visualisation
    @listenTo(@visualisation, 'change', @render)


  render: =>
    if @visualisation.get('data')?
      @$el.html(@template())
      @renderMap()
    else
      @visualisation.getIndicatorData()

    return @

  onClose: ->
    
  renderMap: =>
    @map = L.map(
      @$el.find(".map-visualisation")[0]
    ).fitBounds([
      [26.204734267107604, 57.44750976562499],
      [22.19757745335104, 50.877685546875]
    ])

    L.tileLayer('http://{s}.tiles.mapbox.com/v3/onlyjsmith.map-9zy5lnfp/{z}/{x}/{y}.png', 
    ).addTo(@map);

    styleGeojson =
      "color": "#ff7800"
      "weight": 1
      "opacity": 0.65

    geojsonFeature = @visualisation.get('data')
    L.geoJson(
      geojsonFeature[geojsonFeature.length-1].geometry
      style: styleGeojson
    ).addTo(@map)

    window.m = @map