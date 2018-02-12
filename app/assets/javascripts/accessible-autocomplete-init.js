document.addEventListener('turbolinks:load', function(){
  var element = document.getElementById('register_authority');

  if (element) {
    AccessibleTypeahead.enhanceSelectElement({
      selectElement: element,
      placeholder: "Search for an authority"
    });
  }
});
