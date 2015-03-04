_ = require 'lodash'
synaptic = require 'synaptic'
Neuron = synaptic.Neuron
Layer = synaptic.Layer
Network = synaptic.Network

inputLayer = new Layer 4
hiddenLayers = [
  new Layer 3
  new Layer 2
]
outputLayer = new Layer 1

inputLayer.project hiddenLayers[0]
hiddenLayers[0].project hiddenLayers[1]
hiddenLayers[1].project outputLayer

myNetwork = new Network
  input: inputLayer
  hidden: hiddenLayers
  output: outputLayer
  
learningRate = 0.3

trainingSets = [
  input: [0, 0, 0, 0]
  output: [0]
,
  input: [0, 0, 0, 1]
  output: [0.1]
,
  input: [0, 0, 1, 0]
  output: [0.2]
,
  input: [0, 0, 1, 1]
  output: [0.3]
,
  input: [0, 1, 0, 0]
  output: [0.4]
,
  input: [0, 1, 0, 1]
  output: [0.5]
]

iterations = 0
MSE = 1
while iterations < 20000 and MSE > 0.000005
  loopErrorTotal = 0
  _.each trainingSets, (trainingSet) ->
    currentOutput = myNetwork.activate trainingSet.input
    myNetwork.propagate learningRate, trainingSet.output
    loopErrorTotal += Math.pow currentOutput - trainingSet.output, 2

  MSE = loopErrorTotal / trainingSets.length

console.log myNetwork.activate [0, 1, 0, 1]
console.log myNetwork.activate [0, 1, 1, 1]




# for (var i = 0; i < 20000; i++)
# {
#     // 0,0 => 0
#     myNetwork.activate([0,0]);
#     myNetwork.propagate(learningRate, [0]);

#     // 0,1 => 1
#     myNetwork.activate([0,1]);
#     myNetwork.propagate(learningRate, [1]);

#     // 1,0 => 1
#     myNetwork.activate([1,0]);
#     myNetwork.propagate(learningRate, [1]);

#     // 1,1 => 0
#     myNetwork.activate([1,1]);
#     myNetwork.propagate(learningRate, [0]);
# }


# // test the network
# myNetwork.activate([0,0]); // [0.015020775950893527]
# myNetwork.activate([0,1]); // [0.9815816381088985]
# myNetwork.activate([1,0]); // [0.9871822457132193]
# myNetwork.activate([1,1]); // [0.012950087641929467]