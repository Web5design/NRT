mongoose = require('mongoose')
Section = require('./section.coffee').schema
async = require('async')
_ = require('underscore')

pageModelMixin = require('../mixins/page_model.coffee')

reportSchema = mongoose.Schema(
  title: String
  brief: String
  period: String
  owner: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
)

_.extend(reportSchema.methods, pageModelMixin.methods)
_.extend(reportSchema.statics, pageModelMixin.statics)

Report = mongoose.model('Report', reportSchema)

module.exports = {
  schema: reportSchema
  model: Report
}
