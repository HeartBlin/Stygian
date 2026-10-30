{
  domain = "heartblin.eu";
  mTLS = x: ''
    tls {
      client_auth {
        mode require_and_verify
        trust_pool file {
          pem_file /etc/caddy/root.cert.pem
        }
      }
    }

    ${x}
  '';
}
