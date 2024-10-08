# Setup for LaTeX

yum:
```
sudo yum install texlive-collection-latex texlive-parskip texlive-titlesec
```

apt:

```
sudo apt install texlive-latex-base texlive-latex-recommended texlive-latex-extra
tlmgr init-usertree
tlmgr option repository ftp://tug.org/historic/systems/texlive/2015/tlnet-final
tlmgr install parskip
```

# Setup for GitHub Actions

Need to create a Personal Access Token with `repo` and `user` scopes, and store as a secret called `GH_TOKEN`.

To purge Cloudflare cache, a `CLOUDFLARE_ZONE` and `CLOUDFLARE_TOKEN` (with the `Cache Purge` permission) are also needed.

# Other places containing job details

* https://www.linkedin.com/in/cmbuckley/
    * https://developer.linkedin.com/docs/guide/v2/people/profile-edit-api
* https://stackoverflow.com/users/283078/cmbuckley?tab=profile
    * Manual
* https://en.wikipedia.org/wiki/User:Cbuckley
    * https://www.mediawiki.org/wiki/API:Edit
* https://github.com/cmbuckley/cmbuckley
* https://x.com/_cmbuckley
* https://bsky.app/profile/cmbuckley.me
* https://mastodon.social/@cmbuckley
