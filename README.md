# libretro-loong

```sh {name=restore}
vcs import libretro-super --shallow < lock.repos
```

```sh {name=lock}
vcs export libretro-super --exact > lock.repos
```

```sh {name=clean-f}
vcs custom libretro-super --git --args clean -fdx
vcs custom libretro-super --git --args reset --hard
```

```sh {name=delete}
vcs delete libretro-super -f < lock.repos
```

```sh {name=fetch}
cd libretro-super && SHALLOW_CLONE=1 ./libretro-fetch.sh $(yq '.repositories | keys | map(sub("libretro-","")) | join(" ")' ../lock.repos)
```
