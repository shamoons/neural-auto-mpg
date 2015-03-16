'use strict'

_ = require 'lodash'
brain = require 'brain'
fs = require 'fs'

trainNetwork = (trainNetworkCb) ->
  net = new brain.NeuralNetwork
    hiddenLayers: [8, 8]

  fs.readFile './data/autodata.csv', (err, fileData) ->
    return trainNetworkCb err if err

    fileString = fileData.toString()
    lines = fileString.split '\n'

    trainingData = lines.splice 0, lines.length * 2 / 3

    trainingData = _.map trainingData, (dataPoint) ->
      normalizedData = normalizeData dataPoint
      obj =
        input: normalizedData
        output:
          continuous: normalizedData.continuous

      delete obj.input.continuous

      obj

    net.train trainingData,
      log: true
      logPeriod: 100
      errorThresh: 0.00005
      iterations: 100000
    trainNetworkCb null, net

trainNetwork (err, net) ->
  throw err if err

  fs.readFile './data/autodata.csv', (err, fileData) ->
    return trainNetworkCb err if err

    fileString = fileData.toString()
    lines = fileString.split '\n'

    testData = lines.splice lines.length * 2 / 3
    testData = _.filter testData, (point) ->
      point isnt ''

    testData = _.map testData, (dataPoint) ->
      normalizedData = normalizeData dataPoint
      obj =
        output:
          continuous: normalizedData.continuous
        input: normalizedData

      delete obj.input.continuous

      obj

    _.each testData, (dataPoint) ->
      output = net.run dataPoint.input
      console.log output
      console.log dataPoint
      console.log ''


normalizeData = (dataRow) ->
  dataSet = dataRow.split ','
  dataSet = _.map dataSet, (point) ->
    Number point

  row = {}
  cylinders = [5, 3, 6, 4, 8]

  _.each cylinders, (cylinder) ->
    row["cylinder#{cylinder}"] = if cylinder is dataSet[0] then 1 else 0
    return

  row.displacement = dataSet[1] / 500
  row.horsepower = dataSet[2] / 500
  row.weight = dataSet[3] / 10000
  row.acceleration = dataSet[4] / 100

  model_years = [82,81,80,79,78,77,76,75,74,73,72,71,70]
  _.each model_years, (model_year) ->
    row["model_year#{model_year}"] = if model_year is dataSet[5] then 1 else 0
    return

  origins = [2,3,1]
  _.each origins, (origin) ->
    row["origin#{origin}"] = if origin is dataSet[6] then 1 else 0
    return

  row.continuous = dataSet[7] / 100

  row