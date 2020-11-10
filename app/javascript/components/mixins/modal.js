export default {
  data() {
    return {
      isModalActive: false
    };
  },
  methods: {
    openModal() {
      this.isModalActive = true;
    },
    closeModal() {
      this.isModalActive = false;
    }
  }
};
