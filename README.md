# Deploying ClioPatria

  - Clone this repo
  - copy `data` from a running server
  - Enable nginx support for git.
  - Make and start the container

## NGINX config

Add fetching git repos by adding this to the server config

```
        location ~ /git(/.*) {
            fastcgi_pass  unix:/var/run/fcgiwrap.socket;
            include       fastcgi_params;
            fastcgi_param SCRIPT_FILENAME     /usr/lib/git-core/git-http-backend;
            fastcgi_param GIT_HTTP_EXPORT_ALL "";
            fastcgi_param GIT_PROJECT_ROOT    /home/cliopatria/srv/cliopatria/data;
            fastcgi_param PATH_INFO           $1;
        }
```

Install `fcgiwrap` using

    apt install fcgiwrap

## Notes

There is a bit of a bootstrapping problem here.   `data` cannot be reconstructed easily.
