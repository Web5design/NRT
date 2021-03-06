assert = chai.assert

suite('Line Chart View')

test('when initialised with a visualisation with no data, it fetches the data', ->
  visualisation = Factory.visualisation(
    data: null
  )

  getIndicatorDataStub = sinon.stub(visualisation, 'getIndicatorData', ->)

  view = new Backbone.Views.LineChartView(visualisation: visualisation)

  Helpers.assertCalledOnce(getIndicatorDataStub)

  getIndicatorDataStub.restore()

  view.close()
)

test('.formatData converts sub indicator data in to datasets suitable
  for the LineChart View', ->
  indicatorData =
    results: [
      {
        date: "2013-01-01T01:00:00.000Z",
        "station": [{
          "station": "Al Ein",
          "value": 53.6857,
        }, {
          "station": "Al Wahda",
          "value": 43.6857,
        }]
      }, {
        date: "2013-04-01T01:00:00.000Z",
        "station": [{
          "station": "Al Ein",
          "value": 52.6857,
        }, {
          "station": "Al Wahda",
          "value": 41.6857,
        }]
      }
    ]

  expectedFormattedData =
    labels : ["2013-01-01T01:00:00.000Z", "2013-04-01T01:00:00.000Z"],
    datasets : [
      {
        data : [53.6857, 52.6857]
        title: 'Al Ein'
      },
      {
        data : [43.6857, 41.6857]
        title: 'Al Wahda'
      }
    ]

  indicator = Factory.indicator(
    indicatorDefinition:
      subIndicatorField: 'station'
      xAxis: 'date'
      yAxis: 'value'
  )

  visualisation = Factory.visualisation(
    indicator: indicator
  )

  visualisation.set('data', visualisation.formatData(indicatorData))

  lineChartView = new Backbone.Views.LineChartView(visualisation: visualisation)

  colourRangeStub = sinon.stub(lineChartView, 'generateColourRange', -> {})

  formattedData = lineChartView.formatData(indicatorData)

  assert.deepEqual formattedData, expectedFormattedData,
    "Expected formatData to convert indicator data in to Chart.js standard"

  lineChartView.close()
  colourRangeStub.restore()
)
