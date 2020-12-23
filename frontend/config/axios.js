import axios from 'axios';

// Rails-APIを叩く際のaxiosのcors対策
axios.defaults.baseURL =
  process.env.NODE_ENV === 'production'
                          ? 'https://doit-app.com/api/v1'
                          : 'http://localhost:3000/api/v1';
axios.defaults.withCredentials = true;