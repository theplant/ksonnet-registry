## Before use this registry

You have to install [Ksonnet](ksonnet.io):

```
brew install ksonnet/tap/ks
```

Then init your ks provision files:

```
ks init my-provisioning
```

## Add this registry to your project

```
ks registry add theplant github.com/theplant/ksonnet-registry/tree/master/theplant
```

## Install the package you want to use

Look up the packages

```
ks pkg list

```

Install a certain package

```
ks pkg install theplant/image2url
```

## Use a prototype to generate an app

Look up prototypes

```
ks prototype list
```

Use a prototype to generate

```
ks prototype use jp.theplant.pkg.image2url aigleapp --image=nginx --domain=foo.bar.com --configmap=cm-aigle
```
