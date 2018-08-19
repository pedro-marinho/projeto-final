const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
//mongoose.connect('mongodb://localhost:27017/NodeMCU-NetWork');
mongoose.connect('mongodb://nodemcu-network:nodemcu-networK1@ds125892.mlab.com:25892/nodemcu-network');

module.exports = {mongoose};