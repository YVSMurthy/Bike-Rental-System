const express = require('express');
const { getNearbyBicycles } = require('../../db/bicycle.js');

const router = express.Router();

router.get('/nearby', async (req, res) => {
  try {
    const { locality } = req.query;
    
    if (!locality) {
      return res.status(400).json({ error: 'locality is required' });
    }

    const bicycles = await getNearbyBicycles(locality);
    
    res.json(bicycles.map(bike => ({
      id: bike.id,
      model: bike.model,
      color: bike.color,
      asset_code: bike.asset_code,
      status: bike.status,
      locality: bike.locality
    })));
  } catch (error) {
    console.error('Error fetching nearby bicycles:', error);
    res.status(500).json({ error: 'Failed to fetch bicycles' });
  }
});

module.exports = router;