document.addEventListener("DOMContentLoaded", function () {
  var toggle = document.getElementById("menu-toggle");
  var links = document.getElementById("menu-links");

  if (!toggle || !links) {
    return;
  }

  toggle.addEventListener("click", function () {
    links.classList.toggle("open");
  });
});
