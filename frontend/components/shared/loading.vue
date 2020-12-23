<template>
  <div class="loading-bg-layer">
    <div class="spinner-border"></div>
  </div>
</template>

<style lang="scss" scoped>
@import "../../stylesheets/variables.scss";

.loading-bg-layer {
  background-color: rgba(255, 255, 255, .6);
  position: absolute;
  z-index: 100;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>