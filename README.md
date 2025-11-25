# ebuilds

## build manifest files

```sh
fd '\.ebuild$' | xargs -I _file ebuild _file manifest
```
