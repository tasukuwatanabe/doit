<template>
  <FlashMessage></FlashMessage>
</template>

<style>
._vue-flash-msg-body {
  width: auto !important;
  min-width: 300px;
}
._vue-flash-msg-body ._vue-flash-msg-body__content {
  padding: 20px 30px 20px 20px !important;
}
._vue-flash-msg-body_success {
  background-color:rgba(1,148,122, .9) !important;
}
._vue-flash-msg-body__title,
._vue-flash-msg-body__text {
  margin-bottom: 0 !important;
}
._vue-flash-msg-body__title {
  font-size: 1.1em;
}
._vue-flash-msg-body__icon img {
  width: 35px !important;
}
</style>