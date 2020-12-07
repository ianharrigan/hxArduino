package;

import foo.Varianse.ChildNo1;
import foo.Varianse.ChildNo2;
import foo.Varianse.Base;
import foo.*;

class Main {
    public function setup() {

        /* using abstract type */
        {
            var a1 = new FooAbstract();
            Serial.println(
                a1.FooFunction1(1) + 
                a1.FooFunction2(2) + 
                a1.FooFunction3(3) +
                a1[5]);
        }
        /* end using abstract type */

        /* casting & override */
        {
            var n1 = new ChildNo1();
            var n2 = new ChildNo2();
            var b0 = new Base();
            var castedN1 = cast(n1, Base);
            var castedN2 = cast(n2, Base);
            var result1 = castedN1.getName() == n1.getName(); // asset TRUE
            var result2 = castedN2.getName() == n2.getName(); // asset TRUE
            var result3 = b0.getName() == n2.getName(); // asset FALSE
        }
        /* end casting & override  */

        /* property test */
        {
            var d1 = new BarClass();

            Serial.println(d1.x1);
        }
        /* end property test */

        /* Literals test */
        {
            var mixedArray: Array<Dynamic> = [
                 Literals.n1,
                 Literals.n2, 
                 Literals.n3,
                 Literals.n4, 
                 Literals.n5, 
                 Literals.n6
            ];
            Serial.println(mixedArray.length);
        }
        /* end Literals test */

        SampleFromSite.StaticMethod();
    }
    
    public function loop() { }
    static function main() { }
}