import axios from "axios";

axios.defaults.withCredentials = false;

axios.interceptors.response.use(
  (res) => {
    return res.data;
  },
  (error) => {
    return Promise.reject(error.message);
  }
);

export default axios;
