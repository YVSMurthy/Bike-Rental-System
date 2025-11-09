const express = require('express');
const { getRideSummary, getRideHistory } = require('../../db/ride.js');

const router = express.Router();

router.get('/get-ride-summary', async (req, res) => {
    try {
        const { userId } = req.query;

        if (!userId) {
            return res.status(400).json({ error: 'userId is required' });
        }

        const summary = await getRideSummary(userId);

        res.json({
            totalRides: summary.totalRides,
            totalMinutes: summary.totalMinutes
        });
    } catch (error) {
        console.error('Error fetching ride summary:', error);
        res.status(500).json({ error: 'Failed to fetch ride summary' });
    }
});

router.get('/history', async (req, res) => {
    try {
        const { userId} = req.query;
        if (!userId) return res.status(400).json({ error: 'userId is required' });

        const list = await getRideHistory(userId);
        res.json(list);
    } catch (error) {
        console.error('Error fetching ride history:', error);
        res.status(500).json({ error: 'Failed to fetch ride history' });
    }
});

module.exports = router;