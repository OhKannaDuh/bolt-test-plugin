window.addEventListener('mousedown', (event) => {
  fetch('https://bolt-api/start-reposition?h=0&v=0', {
    method: 'POST',
  });
});
