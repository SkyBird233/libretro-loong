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

```sh {name=fetch-all}
cd libretro-super && SHALLOW_CLONE=1 ./libretro-fetch.sh $(ls ../cores/**/README.md | xargs -n1 yq -f=extract '.core-name')
```
