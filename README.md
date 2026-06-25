# libretro-loong

Libretro cores built for LoongArch.

## Usage

Please visit https://skybird233.github.io/libretro-loong/quick-start.html ([中文版本](https://skybird233.github.io/libretro-loong/zh-cn/quick-start.html)).

If you need more information about a specific core, please refer to `cores/{CORENAME}/README.md`.

## Development

This repo is based on [libretro-super](https://github.com/libretro/libretro-super). We aim to keep LoongArch-specific changes to a minimum so that the scripts inside libretro-super can be reused to fetch and build cores, while custom patches are applied in a custom build environment.

### Build a core locally

Build the container:
```sh {name=build-container}
docker build -t libretro-loongarch-cross .
```

Build the core:
```sh
./scripts/build-ci.sh $CORENAME
```

### Manage core repos

Restore the repos:

```sh {name=restore}
vcs import libretro-super --shallow < lock.repos
```

Lock the repos:

```sh {name=lock}
vcs export libretro-super --exact > lock.repos
```

Clean the repos by removing untracked files and resetting any local changes:

```sh {name=clean-f}
vcs custom libretro-super --git --args clean -fdx
vcs custom libretro-super --git --args reset --hard
```

Delete the repos:

```sh {name=delete}
vcs delete libretro-super -f < lock.repos
```

Deepen the shallow clones by one commit of history for repo updates:

```sh {name=deepen}
vcs custom libretro-super --git --args fetch --deepen 1
```

Fetch all configured cores listed under `cores/**/README.md`:

```sh {name=fetch-all}
cd libretro-super && SHALLOW_CLONE=1 ./libretro-fetch.sh $(ls ../cores/**/README.md | xargs -n1 yq -f=extract '.core-name')
```
