// estimatedCalories.mjs
// Show estimated calories burned at finish

import * as common from '/pages/src/common.mjs';

function calculateCalories(power, seconds) {
    // 1 watt = 3.6 kJ/hour, 1 kcal = 4.184 kJ
    // Calories = (power * seconds / 1000) / 4.184
    return Math.round((power * seconds / 1000) / 4.184);
}

function updateCalories(nearby) {
    // Find the currently watched rider
    const watchingRider = nearby.find(n => n.watching);
    if (!watchingRider) return;
    const avgWatts = watchingRider.stats.power && watchingRider.stats.power.avg ? watchingRider.stats.power.avg : null;
    const elapsedSeconds = watchingRider.state.time;
    // Estimate total ride seconds
    let estimatedTotalSeconds = elapsedSeconds;
    if (watchingRider.stats.speed.avg && watchingRider.state.remaining != null) {
        // remaining is in meters, speed.avg is m/s
        const remainingSeconds = watchingRider.state.remaining / watchingRider.stats.speed.avg;
        estimatedTotalSeconds += remainingSeconds;
    }
    const currentCalories = avgWatts ? calculateCalories(avgWatts, elapsedSeconds) : 'N/A';
    const estimatedCalories = avgWatts ? calculateCalories(avgWatts, estimatedTotalSeconds) : 'N/A';
    document.querySelector('[name="currentCalories"]').textContent = currentCalories + ' kcal';
    document.querySelector('[name="estimatedCalories"]').textContent = estimatedCalories + ' kcal';
}

export function main() {
    common.subscribe('nearby', updateCalories);
    // Optionally, call updateCalories with empty array to clear UI on load
    updateCalories([]);
}
