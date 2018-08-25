# Setup for LaTeX

```
tlmgr init-usertree
tlmgr option repository ftp://tug.org/historic/systems/texlive/2015/tlnet-final
tlmgr install parskip
```

# Travis

```
travis encrypt GIT_TOKEN=cmbuckley:token
travis encrypt CLOUDFLARE_ZONE=zone CLOUDFLARE_TOKEN=token
```

# Other places containing job details

* https://github.com/cmbuckley/cmbuckley.github.io/blob/master/_config.yml
    * Travis to create a PR
* https://www.linkedin.com/in/cmbuckley/
    * https://developer.linkedin.com/docs/guide/v2/people/profile-edit-api
* https://stackoverflow.com/users/283078/cmbuckley?tab=profile
    * Manual
* https://github.com/cmbuckley
    * https://developer.github.com/v3/users/#update-the-authenticated-user
