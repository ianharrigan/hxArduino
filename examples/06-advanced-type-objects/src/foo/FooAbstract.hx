package foo;


abstract FooAbstract(Int) from Int to Int {

    public function new() 
        this = 0;

    public static function FooStaticFunction(): FooAbstract
        return 1 + 1;
    public function FooFunction1(i: Int): FooAbstract
        return i++;
    public function FooFunction2(i: Int): FooAbstract
        return i + IncrementThis1();
    public function FooFunction3(f: FooAbstract): Int
        return f.IncrementThis2();

    public function IncrementThis1(): FooAbstract 
        return this + 1;
    public inline function IncrementThis2(): FooAbstract 
        return this++ + ++this;

    @:op(A + B)
    public function op_add(b: Int): FooAbstract 
        return this + b;


    @:arrayAccess
    public inline function incrementWithIndexer(value:Int): FooAbstract {
        return this + value;
    }
}