window.Backbone.Models || = {}

class window.Backbone.Models.Indicator extends Backbone.RelationalModel
  idAttribute: '_id'

  relations: [
    key: 'sections'
    type: Backbone.HasMany
    relatedModel: 'Backbone.Models.Section'
    collectionType: 'Backbone.Collections.SectionCollection'
    reverseRelation:
      key: 'parent'
      includeInJSON: false
  ]


#For backbone relational
Backbone.Models.Indicator.setup()
