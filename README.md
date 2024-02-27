# My dotfiles

Inspired by ThePrimeagen's [dotfiles](https://github.com/ThePrimeagen/.dotfiles) and by this [blog post](https://www.taniarascia.com/git-submodules-private-content/).

## Setting up a new machine

```sh
cd ~
git clone --recurse-submodules https://github.com/micangl/.dotfiles
```

## Pulling changes

To pull the current repository, and all the submodules, execute
```sh
git pull --recurse-submodules
```

## Making changes

Changes to a submodule must be added and committed both inside the submodule, and in the base repository (`.dotfiles` in this case).

To push eventual changes, run
```sh
git push --recurse-submodules=on-demand
```

## Adding submodules

```sh
git submodule add <url_to_the_submodule> <path_to_the_submodule>
cd <path_to_the_submodule>
git checkout master
```

Go back to the main `.dotfiles` directory and execute
```sh
git config -f .gitmodules submodule.<name>.branch master
git config -f .gitmodules submodule.<name>.update merge
```

Running `git status` will show that some are unstaged; add, commit and push them.
Remember to update the `install` script.
