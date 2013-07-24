// Generated by CoffeeScript 1.6.2
(function() {
  var _base, _base1, _base2,
    __slice = [].slice,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (_base = window.Backbone).Diorama || (_base.Diorama = {});

  Backbone.Diorama.Controller = (function() {
    function Controller() {}

    _.extend(Controller.prototype, Backbone.Events);

    Controller.prototype.changeStateOn = function() {
      var boundTransition, transitionBinding, transitionBindings, _i, _len, _results,
        _this = this;

      transitionBindings = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.stateEventBindings || (this.stateEventBindings = []);
      _results = [];
      for (_i = 0, _len = transitionBindings.length; _i < _len; _i++) {
        transitionBinding = transitionBindings[_i];
        boundTransition = (function() {
          var newState;

          newState = transitionBinding.newState;
          return function() {
            return _this.transitionToState(newState, arguments);
          };
        })();
        transitionBinding.publisher.on(transitionBinding.event, boundTransition);
        _results.push(this.stateEventBindings.push({
          publisher: transitionBinding.publisher,
          event: transitionBinding.event,
          transition: boundTransition
        }));
      }
      return _results;
    };

    Controller.prototype.clearStateEventBindings = function() {
      _.each(this.stateEventBindings, function(binding) {
        return binding.publisher.off(binding.event, binding.transition);
      });
      return this.stateEventBindings = [];
    };

    Controller.prototype.transitionToState = function(state, eventArguments) {
      this.clearStateEventBindings();
      return state.apply(this, eventArguments);
    };

    return Controller;

  })();

  (_base1 = window.Backbone).Diorama || (_base1.Diorama = {});

  Backbone.Diorama.ManagedRegion = (function() {
    function ManagedRegion(options) {
      this.tagName = (options != null ? options.tagName : void 0) || 'div';
      this.$el = $("<" + this.tagName + ">");
    }

    ManagedRegion.prototype.showView = function(view) {
      if (this.currentView) {
        this.currentView.close();
      }
      this.currentView = view;
      this.currentView.render();
      return this.$el.html(this.currentView.el);
    };

    ManagedRegion.prototype.isEmpty = function() {
      return this.$el.is(':empty');
    };

    return ManagedRegion;

  })();

  _.extend(Backbone.View.prototype, {
    bindTo: function(model, ev, callback) {
      model.bind(ev, callback, this);
      if (this.bindings == null) {
        this.bindings = [];
      }
      return this.bindings.push({
        model: model,
        ev: ev,
        callback: callback
      });
    },
    unbindFromAll: function() {
      if (this.bindings != null) {
        _.each(this.bindings, function(binding) {
          return binding.model.unbind(binding.ev, binding.callback);
        });
      }
      return this.bindings = [];
    },
    close: function() {
      this.unbindFromAll();
      this.unbind();
      this.remove();
      if (this.onClose) {
        return this.onClose();
      }
    }
  });

  window.Backbone || (window.Backbone = {});

  (_base2 = window.Backbone).Views || (_base2.Views = {});

  Backbone.Diorama.NestingView = (function(_super) {
    __extends(NestingView, _super);

    function NestingView() {
      this.addSubViewTo = __bind(this.addSubViewTo, this);      Handlebars.registerHelper('addSubViewTo', this.addSubViewTo);
      NestingView.__super__.constructor.apply(this, arguments);
    }

    NestingView.prototype.addSubViewTo = function(view, subViewName, options) {
      return this.addSubView.call(view, subViewName, options);
    };

    NestingView.prototype.addSubView = function(viewName, options) {
      var View, view, viewOptions;

      viewOptions = options.hash || {};
      View = Backbone.Views[viewName];
      view = new View(viewOptions);
      this.subViews || (this.subViews = []);
      this.subViews.push(view);
      return this.generateSubViewPlaceholderTag(view);
    };

    NestingView.prototype.generateSubViewPlaceholderTag = function(subView) {
      var html;

      html = "<" + subView.tagName + " data-sub-view-cid=\"" + subView.cid + "\"></" + subView.tagName + ">";
      return new Handlebars.SafeString(html);
    };

    NestingView.prototype.renderSubViews = function() {
      var subView, _i, _len, _ref, _results;

      if (this.subViews != null) {
        _ref = this.subViews;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          subView = _ref[_i];
          subView.setElement(this.$el.find("[data-sub-view-cid=\"" + subView.cid + "\"]"));
          _results.push(subView.render());
        }
        return _results;
      }
    };

    NestingView.prototype.closeSubViews = function() {
      var subView, _i, _len, _ref;

      if (this.subViews != null) {
        _ref = this.subViews;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          subView = _ref[_i];
          subView.onClose();
          subView.close();
        }
      }
      return this.subViews = [];
    };

    return NestingView;

  })(Backbone.View);

}).call(this);