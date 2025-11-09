const { supabase } = require('../service/supabaseClient.js');

async function getRideSummary(userId) {
    try {
        // Get the first and last day of current month
        const now = new Date();
        const firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
        const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59);

        const { data, error } = await supabase
            .from("rides")
            .select("billed_seconds, start_time")
            .eq("user_id", userId)
            .gte("start_time", firstDay.toISOString())
            .lte("start_time", lastDay.toISOString());

        if (error) throw error;

        const totalRides = data.length;
        const totalSeconds = data.reduce((sum, ride) => sum + (ride.billed_seconds || 0), 0);
        const totalMinutes = Math.floor(totalSeconds / 60);


        return {
            totalRides,
            totalMinutes
        };
    } catch (error) {
        console.error('Error in getRideSummary:', error);
        throw error;
    }
}

async function getRideHistory(userId) {
    try {
        // Base query
        let query = supabase
            .from('rides')
            .select('id, amount_total, billed_seconds, start_time, end_time, start_locality, end_locality, distance_km')
            .eq('user_id', userId)
            .eq('status', 'completed')
            .order('start_time', { ascending: false });

        const { data, error } = await query;
        if (error) throw error;

        const items = (data || []).map(r => ({
            id: r.id,
            from: r.start_locality || '—',
            to: r.end_locality || '—',
            durationMinutes: Math.max(0, Math.floor((r.billed_seconds || 0) / 60)),
            fare: Number(r.amount_total || 0),
            date: (r.end_time || r.start_time),
            distanceKm: r.distance_km || 0,
        }));

        return items;
    } catch (err) {
        console.error('Error in getRideHistory:', err);
        return [];
    }
}

module.exports = { getRideSummary, getRideHistory };