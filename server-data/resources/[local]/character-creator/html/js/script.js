// Character Creator JavaScript
let currentStep = 1;
let characterData = {
    firstName: '',
    lastName: '',
    dateOfBirth: '',
    model: '',
    heritage: { shape: 0, skin: 0 },
    spawnLocation: 1
};

let spawnLocations = [];
let pedModels = [];

// Listen for messages from client
window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'showCharacterCreator') {
        document.getElementById('character-creator').classList.remove('hidden');
        spawnLocations = data.spawnLocations;
        pedModels = data.pedModels;
        initializeUI();
    } else if (data.type === 'hideCharacterCreator') {
        document.getElementById('character-creator').classList.add('hidden');
    }
});

// Initialize UI elements
function initializeUI() {
    // Initialize model selector
    const modelSelector = document.getElementById('modelSelector');
    modelSelector.innerHTML = '';

    pedModels.forEach((model, index) => {
        const card = document.createElement('div');
        card.className = 'model-card';
        card.innerHTML = `<h4>${model.name}</h4>`;
        card.onclick = () => selectModel(model.model, card);
        modelSelector.appendChild(card);
    });

    // Initialize spawn selector
    const spawnSelector = document.getElementById('spawnSelector');
    spawnSelector.innerHTML = '';

    spawnLocations.forEach((location, index) => {
        const card = document.createElement('div');
        card.className = 'spawn-card';
        card.innerHTML = `<h4>${location.name}</h4><p>Spawn Location</p>`;
        card.onclick = () => selectSpawn(index + 1, card);
        spawnSelector.appendChild(card);
    });
}

// Select model
function selectModel(model, element) {
    // Remove previous selection
    document.querySelectorAll('.model-card').forEach(card => {
        card.classList.remove('selected');
    });

    // Add selection
    element.classList.add('selected');
    characterData.model = model;

    // Preview character
    previewCharacter();
}

// Change heritage
function changeHeritage(preset) {
    const heritagePresets = [
        { shape: 0, skin: 0 },
        { shape: 3, skin: 3 },
        { shape: 6, skin: 6 },
        { shape: 9, skin: 9 }
    ];

    // Remove previous selection
    document.querySelectorAll('.heritage-selector button').forEach(btn => {
        btn.classList.remove('selected');
    });

    // Add selection
    event.target.classList.add('selected');
    characterData.heritage = heritagePresets[preset];

    // Preview character
    previewCharacter();
}

// Select spawn location
function selectSpawn(index, element) {
    // Remove previous selection
    document.querySelectorAll('.spawn-card').forEach(card => {
        card.classList.remove('selected');
    });

    // Add selection
    element.classList.add('selected');
    characterData.spawnLocation = index;
}

// Preview character
function previewCharacter() {
    fetch(`https://${GetParentResourceName()}/previewCharacter`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            model: characterData.model,
            heritage: characterData.heritage
        })
    });
}

// Navigation
function nextStep() {
    // Validate current step
    if (currentStep === 1) {
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const dateOfBirth = document.getElementById('dateOfBirth').value;

        if (!firstName || !lastName || !dateOfBirth) {
            showNotification('Please fill in all fields', 'error');
            return;
        }

        // Check age (must be 18+)
        const birthDate = new Date(dateOfBirth);
        const today = new Date();
        const age = today.getFullYear() - birthDate.getFullYear();

        if (age < 18) {
            showNotification('Character must be at least 18 years old', 'error');
            return;
        }

        characterData.firstName = firstName;
        characterData.lastName = lastName;
        characterData.dateOfBirth = dateOfBirth;
    } else if (currentStep === 2) {
        if (!characterData.model) {
            showNotification('Please select a character model', 'error');
            return;
        }
    }

    // Move to next step
    if (currentStep < 3) {
        currentStep++;
        updateStep();
    }
}

function previousStep() {
    if (currentStep > 1) {
        currentStep--;
        updateStep();
    }
}

function updateStep() {
    // Hide all steps
    document.querySelectorAll('.step').forEach(step => {
        step.classList.remove('active');
    });

    // Show current step
    document.getElementById(`step${currentStep}`).classList.add('active');

    // Update progress bar
    const progress = (currentStep / 3) * 100;
    document.getElementById('progressBar').style.width = `${progress}%`;
    document.getElementById('currentStep').textContent = currentStep;
}

// Create character
function createCharacter() {
    // Validate
    if (!characterData.spawnLocation) {
        showNotification('Please select a spawn location', 'error');
        return;
    }

    // Send to client
    fetch(`https://${GetParentResourceName()}/createCharacter`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(characterData)
    }).then(() => {
        showNotification('Character created successfully!', 'success');
    });
}

// Show notification
function showNotification(message, type) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'error' ? '#e74c3c' : '#2ecc71'};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
        z-index: 10000;
        animation: slideInRight 0.3s ease-out;
    `;

    document.body.appendChild(notification);

    // Remove after 3 seconds
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Helper function to get resource name
function GetParentResourceName() {
    return 'character-creator';
}

// Close on ESC
document.addEventListener('keyup', (e) => {
    if (e.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeCreator`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
});

// Add animations to CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
