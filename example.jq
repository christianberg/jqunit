import "jqunit" as t;

t::testsuite([1,2,3,4,5] | [
  t::test("1 is truthy"; 1 | t::assert_true),
  t::test("null is falsy"; null | t::assert_false),
  t::test("Addition"; (1+2) | t::assert_equals(3)),
  t::test("Length"; length | t::assert_equals(5)),
  t::test("Length of input"; t::assert(length | .==5)),
  t::test("Square root of 2"; 2 | sqrt | t::assert_approximate(1.4146))
])




|

.
