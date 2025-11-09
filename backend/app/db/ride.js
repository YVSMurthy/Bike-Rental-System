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

module.exports = { getRideSummary };