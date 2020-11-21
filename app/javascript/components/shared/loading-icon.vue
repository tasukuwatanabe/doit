<template>
  <div class="loading-case" ref="content"></div>
</template>

<script>
export default {
  data: () => ({
    type: "scale"
  }),
  mounted() {
    this.openLoading(this.type);
  },
  methods: {
    openLoading(type) {
      const loading = this.$vs.loading({
        target: this.$refs.content,
        type,
        opacity: '0',
        color: '#3d91be',
        text: "Loading...",
        scale: '1.2',
      });
    }
  }
}
</script>

<style>
  .loading-case {
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
  }
  .vs-loading {
    position: static;
  }
  .vs-loading__load__text {
    font-size: 10px;
    font-weight: normal;
    margin: 5px;
  }
</style>