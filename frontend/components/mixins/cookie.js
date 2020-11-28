function cookieStatus() {
  const cookie_user_id = document.cookie.replace(
    /(?:(?:^|.*;\s*)user_id\s*([^;]*).*$)|^.*$/,
    '$1'
  );
  const cookie_remember_token = document.cookie.replace(
    /(?:(?:^|.*;\s*)remember_token\s*([^;]*).*$)|^.*$/,
    '$1'
  );

  return cookie_user_id != '' && cookie_remember_token != '';
}

function deleteCookie() {
  document.cookie = 'user_id=;';
  document.cookie = 'remember_token=;';
}

export { cookieStatus, deleteCookie };
