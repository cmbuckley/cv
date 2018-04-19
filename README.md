# Setup for LaTeX

tlmgr init-usertree
tlmgr option repository ftp://tug.org/historic/systems/texlive/2015/tlnet-final
tlmgr install parskip

# Travis

travis encrypt GIT_TOKEN=cmbuckley:token
travis encrypt CLOUDFLARE_ZONE=zone CLOUDFLARE_TOKEN=token
