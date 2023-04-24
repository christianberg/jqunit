module {};

def _format_test_result:
  length as $total_tests |
  (map(select(.pass | not)) | length) as $failed_tests |
  map(
    (if .pass then "OK  " else "FAIL" end) as $status |
    (if .pass then
      ""
    else
      .message |
      [strings, arrays] |
      flatten |
      map("     \(.)") |
      [""] + . |
      join("\n")
    end) as $msg |
    "\($status) \(.name)\($msg)"
  ) +
  ["", "Summary: \($failed_tests) of \(length) tests failed"] |
  join("\n")
;

def testsuite(tests):
  . as $input |
  if env.JQUNIT_RUN then
    tests |
    _format_test_result |
    halt_error
  else
    .
  end
;

def test($name; assertion):
  {name: $name, pass: true} as $result |
  try (assertion | $result)
  catch (. as $msg | $result | .pass = false | .message = $msg)
;

def assert(check; $message):
  (. | check) // error([$message, "Input: \(.)"])
;

def assert(check):
  assert(check; "Assert failed")
;

def assert_true:
  assert(.; "Input is not true")
;

def assert_false:
  assert(. | not; "Input is not false")
;

def assert_equals($expected):
  assert(. == $expected; "Expected value: \($expected)")
;

def assert_approximate($expected):
  assert(
    [[.], [$expected]] | map(flatten) | transpose | map((.[0] - .[1]) | fabs < 0.0001) | all;
    "Expected approximate value: \($expected)")
;
