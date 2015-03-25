_ = require 'lodash'
synaptic = require 'synaptic'

Layer = synaptic.Layer
Network = synaptic.Network
Trainer = synaptic.Trainer


trainingData = []
for i in [0..100]
  input = _.random 1, 100
  output = (1 + Math.sin input) / 2

  trainingData.push
    input: [input / 100]
    output: [output]

console.log trainingData

inputLayer = new Layer 1
hiddenLayers = [
  new Layer 64
  # new Layer 10
  # new Layer 32
  # new Layer 16
  # new Layer 8
  # new Layer 4
]
outputLayer = new Layer 1

inputLayer.project hiddenLayers[0]
hiddenLayers[0].project outputLayer

myNetwork = new Network
  input: inputLayer
  hidden: hiddenLayers
  output: outputLayer

trainer = new Trainer myNetwork

trainingResults = trainer.train trainingData,
  rate: [0.2, 0.1, 0.05, 0.04, 0.03, 0.02, 0.01, 0.005, 0.004, 0.003, 0.002, 0.001]
  iterations: 250000
  error: 0.001
  shuffle: true
  customLog:
    every: 100
    do: (result) ->
      console.log "(#{process.pid}) Iteration: #{result.iterations}\tError: #{result.error.toFixed(8)}\tcurrentLearningRate: #{result.rate}"
