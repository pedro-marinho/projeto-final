const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/NodeMCU-NetWork');

module.exports = {mongoose};