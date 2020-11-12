<template>
  <footer class="footer">
    &copy; 2020 Tasuku Watanabe.
  </footer>
</template>

<script>
$(function() {
  $("#hamburger, #screen-layer, #slide-menu a").click(function() {
    $("body").toggleClass("menu-open");
  });
});
</script>
