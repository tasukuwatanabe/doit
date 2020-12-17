import axios from 'axios';

// storeの読み込み
import store from '../store/index';

// Rails-APIを叩く際のaxiosのcors対策
const url =
  process.env.NODE_ENV === 'production'
    ? 'https://doit-app.com/api/v1'
    : 'http://localhost:3000/api/v1';
axios.defaults.baseURL = url;
axios.defaults.withCredentials = true;

// axiosのキャンセルトークンの発行
axios.interceptors.request.use(
  function (config) {
    const source = axios.CancelToken.source();

    config.cancelToken = source.token;

    store.commit('request/addCancelToken', source);

    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
);
