# Installing Haxe


![](../img/install.jpg)


First, you will need to install Haxe (Neko and Haxelib).
There are a couple ways to install Haxe:

* Get the [installer](#haxe) from [haxe.org](http://haxe.org/download/) (original)
* Use [NPM](#npm)
* Use [Homebrew](#brew)
* Use [Chocolatey](#chocolatey)


Although all the installation methods _should_ work. I have use the original installer from haxe.org, and didn't try the other methods.

My suggestion would be to use that one!


<a name="haxe"></a>
## Installer (original) from haxe.org

You can find installers and binaries for Windows, OS X and Linux on [http://haxe.org/download/](http://haxe.org/download/).


<a name="npm"></a>
## Install with NPM (node)

Before you can install Haxe, you have to install Node.js (and thus NPM).
Installing Haxe with NPM makes sense if you have NPM installed already.

But here is the link to install Node.js: [https://nodejs.org/](https://nodejs.org/)

After installation use:

	npm install -g haxe

*[read more about Haxe at NPM](https://www.npmjs.com/package/haxe)*
AND check out all the [Haxe related projects](https://www.npmjs.com/browse/keyword/haxe) on NPM.

<a name="brew"></a>
## Install with Homebrew

Same as with Node.js, you probably want to use Homebrew if you have this already installed.
Worth mentioning: this works on OS X.

Visit [http://brew.sh/](http://brew.sh/) to get instruction how to install Homebrew.

After installation use: (install latest from git with --HEAD)

	brew install haxe --HEAD


<a name="chocolatey"></a>
## Install with chocolatey

This is a Windows install method. You can get your Chocolatey install instructions from [chocolatey.org](https://chocolatey.org/)

After installation use:

	choco install haxe

---