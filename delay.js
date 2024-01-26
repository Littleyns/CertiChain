// delay.js
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

delay(5000).then(() => process.exit(0)); // Attend 5 secondes
