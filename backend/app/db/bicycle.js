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

async function getBicycleByCode(code) {
    const { data, error } = await supabase
        .from('bicycles')
        .select('id, model, color, asset_code, status, locality')
        .or(`id.eq.${code},asset_code.eq.${code}`)
        .single();

    if (error) {
        console.error("Bike lookup error:", error);
        return null;
    }

    return data;
}


module.exports = { getNearbyBicycles, getBicycleByCode };
