<template>
  <FlashMessage></FlashMessage>
</template>

<style>
._vue-flash-msg-body {
  width: auto !important;
  min-width: 300px;
  z-index: 1000;
}
._vue-flash-msg-body ._vue-flash-msg-body__content {
  padding: 25px 25px 25px 20px !important;
}
._vue-flash-msg-body_error {
  background-color:rgba(238, 69, 69, 0.88) !important;
}
._vue-flash-msg-body_success {
  background-color:rgba(1,148,122, .88) !important;
}
._vue-flash-msg-body__title,
._vue-flash-msg-body__text {
  margin-bottom: 0 !important;
}
._vue-flash-msg-body__title {
  font-size: 1.1em;
}
._vue-flash-msg-body__icon {
  padding-left: 15px !important;
  padding-right: 15px !important;
}
._vue-flash-msg-body__icon img {
  width: 35px !important;
}
</style>