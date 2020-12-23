const cookieStatus = () => {
  const cookie_user_id = document.cookie.replace(
    /(?:(?:^|.*;\s*)user_id\s*=\s*([^;]*).*$)|^.*$/,
    '$1'
  );
  const cookie_remember_token = document.cookie.replace(
    /(?:(?:^|.*;\s*)remember_token\s*=\s*([^;]*).*$)|^.*$/,
    '$1'
  );

  return cookie_user_id != '' && cookie_remember_token != '';
};

const deleteCookie = () => {
  document.cookie = 'user_id=;';
  document.cookie = 'remember_token=;';
};

export { cookieStatus, deleteCookie };
