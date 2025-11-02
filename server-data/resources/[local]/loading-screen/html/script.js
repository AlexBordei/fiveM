let loadingProgress = 0;
let progressBar = document.querySelector('.loading-progress');
let loadingText = document.querySelector('.loading-text');

// Listen for loading progress events from FiveM
window.addEventListener('message', function(e) {
    if (e.data.eventName === 'loadProgress') {
        loadingProgress = e.data.loadFraction * 100;
        progressBar.style.width = loadingProgress + '%';

        // Update loading text based on progress
        if (loadingProgress < 30) {
            loadingText.textContent = 'Initializing...';
        } else if (loadingProgress < 60) {
            loadingText.textContent = 'Loading resources...';
        } else if (loadingProgress < 90) {
            loadingText.textContent = 'Almost there...';
        } else {
            loadingText.textContent = 'Welcome to Legacy Romania!';
        }
    }
});

// Handler for when loading is complete
const handlers = {
    startInitFunctionOrder(data) {
        loadingText.textContent = 'Starting game...';
    },

    performMapLoadFunction(data) {
        loadingText.textContent = 'Loading map...';
    },

    startDataFileEntries(data) {
        loadingText.textContent = 'Loading assets...';
    }
};

window.addEventListener('message', function(e) {
    (handlers[e.data.eventName] || function() {})(e.data);
});
