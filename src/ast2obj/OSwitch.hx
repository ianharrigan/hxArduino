package ast2obj;

class OSwitch extends OExpression {
    public var expression:OExpression;
    public var cases:Array<OCase> = [];
    public var defaultExpression:OExpression;
}