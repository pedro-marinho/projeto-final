const express = require('express');
const bodyParser = require('body-parser');

const {Value} = require('./models/valueModel');

const app = express();

app.use(bodyParser.json());

app.post('/values', (req, res) => {
    var values = [];

    req.body.forEach(v => {
        values.push(new Value({
            value: v.value,
            sensor: v.sensor,
            time: v.time
        }));
    });

    Value.collection.insert(values, (e, docs) => {
        if(e) {
            res.sendStatus(404);
            return;
        }

        res.sendStatus(200);
    });
});

app.listen(3000, '192.168.0.11', () => {
    console.log('Server is running on port 3000');
});