const express = require('express');
const { supabase } = require('../../service/supabaseClient.js');

const router = express.Router();

router.get("/test", (req, res) => {
    res.json({ message: "Auth route is working!" });
})

router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password,
        });

        if (error) throw error;

        res.status(200).json({
            message: 'Login successful!',
            user: data.user,
            session: data.session,
        });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

router.post('/signup', async (req, res) => {
    const { name, phone, email, password } = req.body;

    try {
        const { data, error } = await supabase.auth.signUp({
            email,
            password,
            options: { data: { name, phone } },
        });

        if (error) throw error;

        res.status(201).json({
            message: 'Signup successful! Check your email to verify your account.',
            user: data.user,
        });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

module.exports = router;
