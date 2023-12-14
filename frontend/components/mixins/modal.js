export default {
  data() {
    return {
      modalActive: false,
      errors: {},
    };
  },
  methods: {
    toggleModal() {
      this.modalActive = !this.modalActive;
      this.errors = {};
    },
  },
};
