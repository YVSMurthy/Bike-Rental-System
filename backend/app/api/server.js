const express = require('express');
const cors = require('cors');
require('dotenv').config();
const authRouter = require('./routes/auth');
const ridesRouter = require('./routes/rides');
const bicyclesRouter = require('./routes/bicycles');
const walletRouter = require('./routes/wallet');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.status(200).send({"message": "Server is running"});
})

app.use("/auth", authRouter);
app.use("/rides", ridesRouter);
app.use("/bicycles", bicyclesRouter);
app.use("/wallet", walletRouter);

app.listen(PORT);
