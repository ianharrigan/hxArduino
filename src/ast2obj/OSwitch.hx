package ast2obj;

class OSwitch extends OExpression {
    public var type:OType;
    public var expression:OExpression;
    public var cases:Array<OCase> = [];
    public var defaultExpression:OExpression;
}