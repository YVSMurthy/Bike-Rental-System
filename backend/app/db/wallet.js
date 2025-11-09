const { supabase } = require('../service/supabaseClient.js');

async function getWalletSummaryAndTransactions(userId) {
    try {
        const { data: walletData } = await supabase
            .from('wallets')
            .select('balance')
            .eq('user_id', userId)
            .single();

        const balance = walletData?.balance ?? 0;

        const { data: txData } = await supabase
            .from('wallet_transactions')
            .select('amount, description, created_at')
            .eq('user_id', userId)
            .order('created_at', { ascending: false });

        return {
            balance,
            transactions: txData || []
        };
    } catch (error) {
        console.error('Wallet Fetch Error:', error);
        return { balance: 0, transactions: [] };
    }
}

module.exports = { getWalletSummaryAndTransactions };
