<template>
  <div v-if="flash.length" class="alert__case">
    <div class="alert alert-<%= message_type %>">flashメッセージ</div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      flash: []
    };
  }
};
</script>
