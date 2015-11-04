#
# state.coffee: update browser history
#
# Copyright 2013 Canopy Canopy Canopy, Inc.
#
class Alongslide::State

  constructor: (options = {}) ->

    History = window.History

    if !History.enabled then return false

    @documentTitle = document.getElementsByTagName('title')[0].innerHTML
    @panelNames    = options.panelNames
    @flowNames     = options.flowNames
    @panelIndices  = options.panelIndices
    @flowIndices   = options.flowIndices
    @hashIndices   = []
    @hash          = '#'

  setIndices:(arr) ->
    @hashIndices = arr
    # Manually pushing 'digital-project-context' to sections
    #
    @flowIndices.push('digital-project-context')
    delete @panelIndices[0]

    # Removing `undefined` from `@panelIndices`
    #
    newObj = {}
    ct = 1
    for i of @panelIndices
      if @panelIndices[i] != undefined
        newObj[ct] = @panelIndices[i]
        ++ct
    @panelIndices = newObj

  rewindIndex:(state) ->
    state.index -= 1
    @updateLocation(state);

  updateLocation:(state = {})->

    # Account for layouts that only have one section, as the `position`s
    # won't be in the indices array.
    #
    if !@hashIndices[state.index] and state.index > -1
      @rewindIndex(state)

    # Exit if the indices array is empty
    #
    else if state.index < 0
      return

    # Update the hash
    #
    else if @hashIndices[state.index]
      setTimeout =>
        History.replaceState null, @documentTitle, @hash + @hashIndices[state.index]
      , 0

      data =
        index       : state.index
        sectionHash : @flowIndices[state.index]
        panels      : @panelIndices
        sections    : @flowIndices

      $(document).triggerHandler 'alongslide.stateChange', data
