package foo;

class Literals {
    public static var n1: Int = 0xFF42 + 232;
    public static var n2: Float = 0.32 - 3. + 2.1e5;
    public static var n3: Int = "\n".code;
    // TODO need implementation for support anon types
    //public static var n4 = { foo: 1, bar: 2 };
    public static var n5 = 1...3;
    public static var n6 = ["a" => 1];
}