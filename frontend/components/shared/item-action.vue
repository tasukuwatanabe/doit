<template>
  <div class="item-action">
    <a @click="setItem(item)" class="item-action__btn">
      <i class="fas fa-pencil-alt"></i>
    </a>
    <a @click="deleteItem(item)" class="item-action__btn">
      <i class="fas fa-trash"></i>
    </a>
  </div>
</template>

<script>
export default {
  name: "ItemAction",
  props: ['item'],
  methods: {
    setItem() {
      this.$emit('set-item', this.item);
    },
    deleteItem() {
      this.$emit('delete-item', this.item);
    }
  }
}
</script>