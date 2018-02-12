document.addEventListener('turbolinks:load', function() {
  var element = document.getElementById('register_authority');

  if (element) {
    accessibleAutocomplete.enhanceSelectElement({
      selectElement: element
    });
  }
});
