# Requires
_ = require('underscore')
balUtil = require('bal-util')

# Define Plugin
class BasePlugin

	# ---------------------------------
	# Inherited

	# DocPad Instance
	docpad: null

	# Logger Instance
	logger: null


	# ---------------------------------
	# Variables

	# Plugin name
	name: null

	# Plugin config
	config: {}

	# Plugin priority
	priority: 500

	# Event Listing
	events: [
		'docpadReady'
		'consoleSetup'
		'generateBefore'
		'generateAfter'
		'cleanBefore'
		'cleanAfter'
		'parseBefore'
		'parseAfter'
		'renderBefore'
		'render'
		'renderDocument'
		'renderAfter'
		'writeBefore'
		'writeAfter'
		'serverBefore'
		'serverAfter'
	]

	# Constructor
	constructor: (config={}) ->
		# Prepare
		me = @
		@events = _.extend([],@events)
		@config = _.extend({},@config,config)
		@docpad = @config.docpad
		@logger = @docpad.logger
		@name or= @config.name  if @config.name
		if !@name
			throw new Error 'Plugin must have a name'

		# Bind events
		_.each @events, (eventName) ->
			if typeof me[eventName] is 'function'
				# Fetch the event handler
				eventHandler = me[eventName]
				# Wrap the event handler, and bind it to docpad
				me.docpad.on eventName, (opts,next) ->
					# Fire the function, treating the callback as optional
					balUtil.fireWithOptionalCallback(eventHandler, [opts,next], me)

# Export Plugin
module.exports = BasePlugin
