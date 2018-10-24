# Quick install

This tutorial is for the TL;DR crowd...
You just want to get started ... right!

![](../img/tldr.gif)

## Step 0: You have joined an elite Haxe force!

You are cooler then a polar bear!

## Step 1: Install Haxe

You can find installers and binaries for Windows, OS X and Linux on [http://haxe.org/download/](http://haxe.org/download/).

- Download
- And install

## Step 2: Install Editor

You need an editor, lets install **Visual Studio Code**

![Visual Studio Code](https://haxe.org/img/ide/vscode.gif)

On the homepage of [Visual Studio Code](https://code.visualstudio.com/) find the button for your OS.

- Download
- And install

## Step 3: Install VSCode - Haxe Extension Pack

To get VSCode working with Haxe you should install the "Haxe Extension Pack"

([Haxe Extension Pack ](https://marketplace.visualstudio.com/items?itemName=vshaxe.haxe-extension-pack))

- Launch VS Code
- Quick Open (Ctrl+P / ⌘+P)
- Paste the following command: `ext install haxe-extension-pack`
- And type enter

It currently contains 3 extensions

- Haxe ([Haxe Support for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=nadako.vshaxe))
- Haxe Debug ([Haxe Debug for flash target](https://marketplace.visualstudio.com/items?itemName=vshaxe.haxe-debug))
- codedox ([JSDoc style comments](https://marketplace.visualstudio.com/items?itemName=wiggin77.codedox))

But that might become more in the future!

## Step 4 (extra): Install haxelib libraries

This is not necessary but something you eventually need to do.

- Open `terminal`
- Copy and past the following

```
haxelib install hxnodejs
haxelib git js-kit https://github.com/clemos/haxe-js-kit.git haxelib
haxelib install markdown
haxelib install msignal
```

## Step 5 (Extra): Install NPM/Node.js

Download Node.js: get your version here: [https://nodejs.org/](https://nodejs.org/)

- Download
- And install

Now you have access to NPM.

- Open `terminal`
- Copy and paste the following (and see current NPM version)

```
npm -v
```

---
