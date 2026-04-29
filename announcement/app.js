// Store this file next to app.R as app.js.

(function() {
  function syncWorkbenchControls() {
    const tabs = document.getElementById('surface_tabs');
    const trend = document.getElementById('show_smoother');

    if (!tabs || !trend) {
      return;
    }

    trend.disabled = tabs.active !== 'chart';
  }

  function bindWorkbenchControls() {
    const tabs = document.getElementById('surface_tabs');

    if (!tabs || tabs.dataset.workbenchControlsBound) {
      syncWorkbenchControls();
      return;
    }

    tabs.dataset.workbenchControlsBound = 'true';
    tabs.addEventListener('wa-tab-show', syncWorkbenchControls);
    syncWorkbenchControls();
  }

  document.addEventListener('shiny:connected', function() {
    setTimeout(bindWorkbenchControls, 0);
  }, { once: true });

  setTimeout(bindWorkbenchControls, 0);
})();
