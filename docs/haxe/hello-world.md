# Hello world

![](../img/helloworld.png)

Developing JavaScript code is easy with Haxe. Let's see our first HelloWorld example :

```haxe
class Test {
	static function main() {
		trace("Hello World !");
	}
}
```

Put this class into a file named `Test.hx` and create the file `compile.hxml` in the same directory with the following content:

```
-js test.js
-main Test
```

To compile open you terminal and type:

	cd

And drag the folder where you saved the files, into the terminal.
It will look something like this:

	cd /path/to/folder/

Press enter and type:

	haxe compile.hxml

If an error occurs, the terminal will display that.
If everything went smoothly like it should, this will produce a `test.js` file that can be embedded into an HTML page such as this one :

```html
<html>
<head><title>Haxe JS</title></head>
<body>

<script type="text/javascript" src="test.js"></script>

</body>
</html>
```

1. Put this code into a `test.html` file.
2. Open it with your browser (like Google Chrome)
3. It will display **Hello World** in your Console.
4. (Google Chrome > Hamburger menu > More Tools > Developers tools)


## try.haxe

If you want to experiment with this code, you can do that without installing Haxe.

Below you can see and try the same example code at [try.haxe.org](https://try.haxe.org/) without installing Haxe.

<iframe src="https://try.haxe.org/embed/197E1" width="100%" height="300" frameborder="no" allowfullscreen>
	<a href="https://try.haxe.org/#197E1">Try Haxe !</a>
</iframe>


*Based upon [old.haxe.org - manual](http://old.haxe.org/doc/start/js)*
