const { supabase } = require('../service/supabaseClient.js');

async function getNearbyBicycles(locality) {
    try {
        const { data, error } = await supabase
            .from('bicycles')
            .select('id, model, color, asset_code, status, locality')
            .eq('locality', locality)
            .eq('status', 'available');

        if (error) throw error;

        return data || [];
    } catch (error) {
        console.error('Error in getNearbyBicycles:', error);
        throw error;
    }
}

module.exports = { getNearbyBicycles };
