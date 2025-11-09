const express = require('express');
const { getWalletSummaryAndTransactions } = require('../../db/wallet.js');

const router = express.Router();

router.get('/get-wallet-summary', async (req, res) => {
    try {
        const { userId } = req.query;

        if (!userId) {
            return res.status(400).json({ error: 'userId is required' });
        }

        const summary = await getWalletSummaryAndTransactions(userId);

        res.json({
            balance: summary.balance,
            transactions: summary.transactions
        });

    } catch (error) {
        console.error('Error fetching wallet summary:', error);
        res.status(500).json({ error: 'Failed to fetch wallet summary' });
    }
});

module.exports = router;