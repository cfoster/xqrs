(:
  The contents of this file are injected dynamically when running the test suite
:)

import module namespace unmapped-zero-sequence-parameters =
  "/spec/annotations/unmapped-zero-sequence-parameters" at
  "test-suite/xqy/annotations/unmapped-sequence-parameters.xq";

import module namespace parameter-order =
  "/spec/annotations/parameter-order" at
  "test-suite/xqy/annotations/parameter-order.xq";

import module namespace templates =
  "/spec/resource/templates" at
  "test-suite/xqy/resource/templates.xq";
  
import module namespace query-parameters =
  "/spec/resource/function/query-parameters" at
  "test-suite/xqy/resource/function/parameters/query-parameters.xq";

import module namespace query-parameters-alternative =
  "/spec/resource/function/query-parameters-alternative" at
  "test-suite/xqy/resource/function/parameters/query-parameters-alternative.xq";
  
import module namespace form-parameters =
  "/spec/resource/function/form-parameters" at
  "test-suite/xqy/resource/function/parameters/form-parameters.xq";

import module namespace form-parameters-alternative =
  "/spec/resource/function/form-parameters-alternative" at
  "test-suite/xqy/resource/function/parameters/form-parameters-alternative.xq";
  
import module namespace header-parameters =
  "/spec/resource/function/header-parameters" at
  "test-suite/xqy/resource/function/parameters/header-parameters.xq";

import module namespace header-parameters-alternative =
  "/spec/resource/function/header-parameters-alternative" at
  "test-suite/xqy/resource/function/parameters/header-parameters-alternative.xq";

import module namespace cookie-parameters =
  "/spec/resource/function/cookie-parameters" at
  "test-suite/xqy/resource/function/parameters/cookie-parameters.xq";

import module namespace cookie-parameters-alternative =
  "/spec/resource/function/cookie-parameters-alternative" at
  "test-suite/xqy/resource/function/parameters/cookie-parameters-alternative.xq";

import module namespace path-annotation =
  "/spec/resource/function/path-annotation" at
  "test-suite/xqy/resource/function/constraints/path-annotation.xq";

import module namespace method-annotation =
  "/spec/resource/function/method-annotation" at
  "test-suite/xqy/resource/function/constraints/method-annotation.xq";

import module namespace insert-get-delete =
  "/marklogic-tests/insert-get-delete" at
  "test-suite/xqy/marklogic/insert-get-delete.xq";
  
import module namespace transaction-mode =
  "/marklogic-tests/transaction-mode" at
  "test-suite/xqy/marklogic/transaction-mode.xq";

import module namespace errors =
  "/marklogic-tests/errors" at
  "test-suite/xqy/marklogic/errors.xq";

import module namespace dynamic-errors =
  "/marklogic-tests/dynamic-errors" at
  "test-suite/xqy/marklogic/dynamic-errors.xq";

import module namespace function-mapping =
  "/marklogic-tests/function-mapping" at
  "test-suite/xqy/marklogic/function-mapping.xq";

import module namespace xquery30 =
  "/marklogic-tests/xquery3.0" at
  "test-suite/xqy/marklogic/xquery30.xq";
  
import module namespace session-testing =
  "/marklogic-tests/session-testing" at
  "test-suite/xqy/marklogic/session-testing.xq";

import module namespace consumes-annotation =
  "/spec/resource/function/consumes-annotation" at
  "test-suite/xqy/resource/function/constraints/consumes-annotation.xq";
  
import module namespace produces-annotation =
  "/spec/resource/function/produces-annotation" at
  "test-suite/xqy/resource/function/constraints/produces-annotation.xq";

import module namespace constraint-preference =
  "/spec/http-request-matching/constraint-preference" at
  "test-suite/xqy/http-request-matching/constraint-preference.xq";

import module namespace path-preference =
  "/spec/http-request-matching/path-preference" at
  "test-suite/xqy/http-request-matching/path-preference.xq";

import module namespace media-type-preference =
  "/spec/http-request-matching/media-type-preference" at
  "test-suite/xqy/http-request-matching/media-type-preference.xq";

import module namespace combined-preference =
  "/spec/http-request-matching/combined-preference" at
  "test-suite/xqy/http-request-matching/combined-preference.xq";

import module namespace serialization-defaults =
  "/spec/response/serialization/serialization-defaults" at
  "test-suite/xqy/response/serialization/serialization-defaults.xq";
  
import module namespace serialization-parameters =
  "/spec/response/serialization/parameters" at
  "test-suite/xqy/response/serialization/serialization-parameters.xq";

import module namespace serialization-method-rdf =
  "/spec/response/serialization/method/rdf" at
  "test-suite/xqy/response/serialization/serialization-method-rdf.xq";
  
import module namespace response-format =
  "/spec/response/response-format" at
  "test-suite/xqy/response/response-format.xq";

(: --- OPTIONAL LIBRARIES --- :)
import module namespace tx =
  "http://xmllondon.com/xquery/transaction" at
  "optional-libraries/transaction.xq";
  
import module namespace session =
  "http://xmllondon.com/xquery/session" at
  "optional-libraries/session.xq";

import module namespace restxq-function-module =
  "http://exquery.org/ns/restxq" at
  "optional-libraries/restxq-function-module.xq";
  
import module namespace xqrs-functions =
  "http://xmllondon.com/xquery/xqrs-functions" at
  "optional-libraries/xqrs-functions.xq";  
(: -------------------------- :)
