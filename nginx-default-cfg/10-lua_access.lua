local opts = {
    redirect_after_logout_with_id_token_hint = false,
    accept_none_alg = true,
    redirect_uri = "/*",
    discovery = "https://cipiam-cip-apps.apps.ocp.lab-nxtit.com/auth/realms/WEAK-PUBLIC-TEST/.well-known/openid-configuration",
    client_id = "NGINX",
    client_secret = "d1229dcb-4f6e-44e1-adf7-67611424c680",
    redirect_uri_scheme = "https",
    logout_path = "/logout",
    redirect_after_logout_uri = "https://cipiam-cip-apps.apps.ocp.lab-nxtit.com/auth/realms/WEAK-PUBLIC-TEST/protocol/openid-connect/logout?redirect_uri=https://portal-cip-apps.apps.ocp.lab-nxtit.com/",
    redirect_after_logout_with_id_token_hint = false,
    session_contents = {id_token=true},
    #ssl_verify=no
  }

  -- call introspect for OAuth 2.0 Bearer Access Token validation
  local res, err = require("resty.openidc").bearer_jwt_verify(opts)
  if err or not res then
    print("Token authentication not succeeded")
    if err then
      print("jwt_verify error message:")
      print(err)
    end
    if res then
      print("jwt_verify response:")
      tprint(res)
    end
    res, err = require("resty.openidc").authenticate(opts)
    if err then
      ngx.status = 403
      ngx.say(err)
      ngx.exit(ngx.HTTP_FORBIDDEN)
    end
  end

if res.id_token and res.id_token.preferred_username then
    ngx.var.resty_user = res.id_token.preferred_username
  else
    ngx.var.resty_user = res.preferred_username
  end

