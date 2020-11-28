<template>
  <FlashMessage></FlashMessage>
</template>

<style lang="scss">
.alert__case {
  position: absolute !important;
  top: 0;
  left: 0;
  right: 0;
  height: 56px;
  margin: auto !important;
  display: flex;
  max-width: 400px;
  justify-content: center;
  align-items: center;

  .alert {
    padding: 5px 15px;
    font-size: 12px;
    min-width: 300px;
    text-align: center;
    margin-bottom: 0;
  }
}

._vue-flash {
  &-msg-body {
  width: auto !important;
  min-width: 300px;
  z-index: 1000;
    &__content {
      padding: 25px 25px 25px 20px !important;
    }
    &_error {
      background-color:rgba(238, 69, 69, 0.88) !important;
    }
    &_success {
      background-color:rgba(1,148,122, .88) !important;
    }
    &__title,
    &__text {
      margin-bottom: 0 !important;
    }
    &__title {
      font-size: 1.1em;
    }
    &__icon {
      padding-left: 15px !important;
      padding-right: 15px !important;
      img {
        width: 35px !important;
      }
    }
  }
}
</style>