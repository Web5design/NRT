assert = chai.assert

suite('Bar Chart View')

test('when initialised with a visualisation with no data, it fetches the data', (done)->
  visualisation = Factory.visualisation(
    data: null
  )

  getIndicatorDataSpy = sinon.spy(visualisation, 'getIndicatorData')
  visualisation.once('change:data', ->
    assert.ok getIndicatorDataSpy.calledOnce
    done()
  )

  server = sinon.fakeServer.create()

  view = new Backbone.Views.BarChartView(visualisation: visualisation)

  # Check we received a data request
  indicatorId = visualisation.get('indicator').get('_id')
  assert.equal(
    server.requests[0].url,
    "/api/indicators/#{indicatorId}/data"
  )

  # Respond to get data request
  Helpers.SinonServer.respondWithJson.call(server, results: [{some: 'data'}])
  server.restore()

  view.close()
)

test('when initialised it initialises nrtVis.barChart
  with the x and y keys from the indicator definition', (done)->
  indicator = Factory.indicator(
    indicatorDefinition:
      xAxis: 'hat'
      yAxis: 'boat'
  )
  visualisation = Factory.visualisation(
    indicator: indicator
  )

  barChartRenderStub = sinon.stub(Backbone.Views.BarChartView::, 'render', ->)

  barChartStub = sinon.stub(nrtViz, 'barChart', (options) ->
    try
      assert.strictEqual options.xKey, indicator.get('indicatorDefinition').xAxis
      assert.strictEqual options.yKey, indicator.get('indicatorDefinition').yAxis

      done()
    catch e
      done(e)
    finally
      barChartStub.restore()
      barChartRenderStub.restore()
  )

  view = new Backbone.Views.BarChartView(visualisation: visualisation)
  view.close()
)
