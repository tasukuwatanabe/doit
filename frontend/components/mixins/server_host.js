export default {
  methods: {
    getServerHost() {
      return process.env.NODE_ENV === 'production'
        ? 'https://doit-app.com'
        : 'http://localhost:3000';
    },
  },
};
