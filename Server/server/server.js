const express = require('express');
const bodyParser = require('body-parser');

const { Value } = require('./models/valueModel');

const app = express();
app.use(bodyParser.json());

// CORS
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

app.post('/values', (req, res) => {
    try {
        var values = [];

        req.body.forEach(v => {
            values.push(new Value({
                value: v.value,
                sensor: v.sensor,
                time: v.time
            }));
        });

        Value.collection.insert(values, (e, docs) => {
            if (e) {
                res.sendStatus(400);
                return;
            }

            res.sendStatus(200);
        });
    } catch (e) {
        console.log(e);
        res.sendStatus(400);
    }
});

app.get('/values', async (req, res) => {
    try {
        var values = await Value.find();
        res.send({data: values});
    } catch (e) {
        console.log(e);
        res.sendStatus(400);
    }
});

app.get('/sensors', async (req, res) => {
    try {
        var values = await Value.find();
        var sensors = new Set();

        values.forEach(v => sensors.add(v.sensor));
        res.send({data: [...sensors]});
    } catch (e) {
        console.log(e);
        res.sendStatus(400);
    }
});

app.listen(3000, '192.168.0.11', () => {
    console.log('Server is running on port 3000');
});