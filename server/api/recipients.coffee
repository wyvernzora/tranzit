﻿#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

# This file contains route handlers for /recipients subroute

# Here we load utilities from lib directory
util     = require('../lib/util.js')          # Various utility methods
Conveyor = require('../lib/conveyor.js')      # Promise-chaining

# Here we export a high-order function, since we need called to supply db
module.exports = (db) ->

  # Here we load APIs from data access module that are needed in this file
  recipients = require('../models/recipients.js')(db)

  # Object where we will attach our functions
  self = { }

  self.findByID = ->
    return (req, res) ->

      # Schema for required parameters
      schema =
        id: String

      # Promise chain start
      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)

      # Validate request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

        .then
          input: params.id
          output: recipient
          recipients.findByID

        # Make sure the user exists
        .then
          status: 404,
          message: 'Recipient not found.',
          util.exists

        # Send success or observe errors
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self