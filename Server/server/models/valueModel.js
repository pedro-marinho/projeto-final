const {mongoose} = require('./../db/db');

var Value = mongoose.model('Value', {
   value: {
       type: Number,
       required: true
   },
   sensor: {
       type: String,
       required: true
   },
   time: {
       type: Number,
       required: true
   }
});

module.exports = {Value};