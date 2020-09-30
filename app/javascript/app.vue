<template>
  <div id="app">
    <p>{{ message }}</p>
    <b-button variant="success">Button</b-button>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      message: "Hello Vue!"
    };
  }
};
</script>

<style scoped>
#app {
  font-size: 2em;
  text-align: center;
}
</style>
