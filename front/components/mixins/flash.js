export default {
  methods: {
    generateFlash(status, message) {
      this.flashMessage[status]({
        title: message,
        time: 5000,
        icon: `/icons/${status}.svg`,
      });
    },
  },
};
