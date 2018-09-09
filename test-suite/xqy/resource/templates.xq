module namespace templates =
  "/spec/resource/templates";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/resource/templates/1/{$number-of-cats}")
function number-of-cats() {
  "This function should throw an exception"
};

declare
  %rest:path("/resource/templates/2/{$number-of-cats}")
function wrong-variable-name-binding($number-of-dogs as xs:string) {
  "This function should throw an exception"
};

declare
  %rest:path("/resource/templates/3/{$number-of-cats}")
function many-wrong-variable-name-binding(
  $number-of-dogs as xs:string,
  $number-of-guinea-pigs as xs:string) {
  "This function should throw an exception"
};

declare
  %rest:path("/resource/templates/4/{$number-of-cats}")
function good-binding($number-of-cats as xs:string) {
  $number-of-cats
};
