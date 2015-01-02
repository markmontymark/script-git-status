# script-git-status

Check the status of local git repos in a directory.  I usually clone all git repos
in a $HOME/git/ directory.  I sometimes want to see which repos are clean, dirty or not
uploaded to github yet, so I wrote git-status.sh to give me a status.


## setup

Make executable and copy to somewhere in $PATH

```sh
chmod 755 git-status.sh
sudo cp git-status.sh /usr/local/bin
```

## usage

```sh
$ cd $HOME/git
$ git-status.sh
node-scrape-html
patterns
M README.md
./proxy
script-git-status
```

## color meanings

- green - clean status, no changes to stage, commit or push
- red - dirty status, you have changes to stage, commit or push
- blue - no .git/ directory found, so not a git repo

