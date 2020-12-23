export default {
  methods: {
    getUploadHost() {
      return process.env.NODE_ENV === 'production'
        ? 'https://doit-image.s3-ap-northeast-1.amazonaws.com'
        : 'http://localhost:3000';
    },
  },
};
