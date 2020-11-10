export default {
  data() {
    return {
      modalActive: false
    };
  },
  methods: {
    toggleModal() {
      this.modalActive = !this.modalActive;
    }
  }
};
