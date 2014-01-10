assert = chai.assert

suite('ThemeFiltersView')

test('renders a ThemeFilterItem sub view for each theme in the given collection', ->
  indicators = new Backbone.Collections.IndicatorCollection()

  view = new Backbone.Views.ThemeFiltersView(indicators: indicators)

  theme = Factory.theme(title: 'test theme')
  themes = new Backbone.Collections.ThemeCollection([theme])

  view.themes = themes
  view.render()

  assert.match view.$el.text(), new RegExp(theme.get('title')),
    "Expected to see the theme title"

  for key, v of view.subViews
    subView = v

  assert.isDefined subView, "Expected the view to have a subView"
  assert.strictEqual subView.constructor.name, "ThemeFilterItemView",
    "Expected the sub view to be of type 'ThemeFilterItemView'"

  assert.strictEqual subView.theme.cid, theme.cid,
    "Expected the sub view to be for the theme"
)

test("Clicking 'All Indicators' triggers a indicator_selector:theme_selected
event with no arguments", ->
  indicators = new Backbone.Collections.IndicatorCollection()
  view = new Backbone.Views.ThemeFiltersView(indicators: indicators)

  themes = new Backbone.Collections.ThemeCollection([])
  view.themes = themes

  spy = sinon.spy()
  Backbone.on('indicator_selector:theme_selected', spy)

  allIndicatorsEl = view.$el.find('.all-indicators')
  allIndicatorsEl.trigger('click')

  assert.strictEqual spy.callCount, 1,
    "Expected indicator_selector:theme_selected to be triggered"

  assert.isTrue spy.calledWith(undefined),
    "Expected indicator_selector:theme_selected to be triggered with no theme"
)

test("when clicking 'All Indicators', it adds the class 'active' to that LI", ->
  view = new Backbone.Views.ThemeFiltersView(
    indicators: new Backbone.Collections.IndicatorCollection()
  )

  allIndicatorsEl = view.$el.find('.all-indicators')
  allIndicatorsEl.removeClass('active')

  allIndicatorsEl.trigger('click')

  try
    assert.isTrue allIndicatorsEl.hasClass('active'),
      "Expected the view to have the active class"
  finally
    view.close()
)

test("On 'indicator_selector:theme_selected' from another view,
  the active class is removed from the 'All Indicators' element", ->
  view = new Backbone.Views.ThemeFiltersView(
    indicators: new Backbone.Collections.IndicatorCollection()
  )

  allIndicatorsEl = view.$el.find('.all-indicators')
  allIndicatorsEl.addClass('active')

  Backbone.trigger('indicator_selector:theme_selected')

  try
    assert.isFalse allIndicatorsEl.hasClass('active'),
      "Expected the 'All Indicators' element not to have the active class"
  finally
    view.close()
)
