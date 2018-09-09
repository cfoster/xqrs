module namespace serialization-method-rdf =
  "/spec/response/serialization/parameters";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare
  %rest:path("/response/serialization/parameters/allow-duplicate-names")
  %output:allow-duplicate-names("yes")
function allow-duplicate-names() {
  "not supported in this version"
};

declare
  %rest:path("/response/serialization/parameters/byte-order-mark/1")
  %output:byte-order-mark("yes")
function byte-order-mark-1() {
  <e>A</e>
};

declare
  %rest:path("/response/serialization/parameters/byte-order-mark/2")
  %output:byte-order-mark("yes")
function byte-order-mark-2() {
  (: Byte Order Mark must only be produced once :)
  <e>A</e>, <e>B</e>
};

declare
  %rest:path("/response/serialization/parameters/cdata-section-elements")
  %rest:POST("{$data}")
  %output:cdata-section-elements("b")
  %output:omit-xml-declaration("yes")
function cdata-section-elements($data as document-node(element())) {
  (: Can not construct CDATA nodes natively in XQuery.
     Taking a document containing CDATA nodes from the client. :)
  $data
};

declare
  %rest:path("/response/serialization/parameters/doctype-public")
  %output:doctype-public("-//MAJ//MIN//EN")
  %output:doctype-system("example.dtd")
function doctype-public() {
  document { <e>Hello World</e> }
};

declare
  %rest:path("/response/serialization/parameters/doctype-system")
  %output:doctype-system("example.dtd")
function doctype-system() {
  document { <e>Hello World</e> }
};

declare
  %rest:path("/response/serialization/parameters/encoding/iso-8859-1")
  %output:encoding("iso-8859-1")
function encoding() {
  "£"
};

declare
  %rest:path("/response/serialization/parameters/escape-uri-attributes")
  %output:escape-uri-attributes("yes")
  %output:method("html")
  %output:indent("no")
function escape-uri-attributes() {
  <html><head/><body><a href="/d/b&#xe9;b&#xe9;.xml">text</a></body></html>
};

declare
  %rest:path("/response/serialization/parameters/html-version")
  %output:html-version("5.0")
  %output:method("html")
function html-version() {
  "not supported in this version"
};

declare
  %rest:path("/response/serialization/parameters/include-content-type/yes")
  %output:include-content-type("yes")
  %output:method("xhtml")
  %output:indent("no")
function include-content-type-yes() {
  <html><head/><body/></html>
};

declare
  %rest:path("/response/serialization/parameters/include-content-type/no")
  %output:include-content-type("no")
  %output:method("xhtml")
function include-content-type-no() {
  <html><head/><body/></html>
};

declare
  %rest:path("/response/serialization/parameters/indent/yes")
  %output:indent("yes")
function indent-yes() {
  <i><j><k>Hello World</k></j></i>
};

declare
  %rest:path("/response/serialization/parameters/indent/no")
  %output:indent("no")
function indent-no() {
  <i><j><k>Hello World</k></j></i>
};

declare
  %rest:path("/response/serialization/parameters/indent-untyped/yes")
  %output:indent-untyped("yes")
function indent-untyped-yes() {
  <i><j><k>Hello World</k></j></i>
};

declare
  %rest:path("/response/serialization/parameters/indent-untyped/no")
  %output:indent-untyped("no")
function indent-untyped-no() {
  <i><j><k>Hello World</k></j></i>
};

declare
  %rest:path("/response/serialization/parameters/item-separator/1")
  %output:item-separator("X")
function item-separator-1() {
  "A", "B", "C", "D"
};

declare
  %rest:path("/response/serialization/parameters/item-separator/2")
  %output:item-separator("...")
  %rest:method("xml")
function item-separator-2() {
  <a>Hello</a>,
  "World",  
  1234,
  xs:date("2001-01-01")
};

declare
  %rest:path("/response/serialization/parameters/json-node-output-method")
  %output:json-node-output-method("xml")
function json-node-output-method() {
  "not supported in this version"
};

declare
  %rest:path("/response/serialization/parameters/media-type")
  %output:media-type("text/my-special-text-type")
function media-type() {
  "Hello World"
};

declare
  %rest:path("/response/serialization/parameters/method/xml")
  %output:method("xml")
function method-xml() {
  <e>Hello World</e>
};

declare
  %rest:path("/response/serialization/parameters/method/text")
  %output:method("text")
function method-text() {
  <e>Hello World</e>
};

declare
  %rest:path("/response/serialization/parameters/normalization-form/text")
  %output:normalization-form("NFC")
function normalization-form-text() {
  "suc&#807;on" (: should produce "su&#231;on" :)
};

declare
  %rest:path("/response/serialization/parameters/normalization-form/xml")
  %output:normalization-form("NFC")
function normalization-form-xml() {
  <e>suc&#807;on</e> (: should produce <e>su&#231;on</e> :)
};

declare
  %rest:path("/response/serialization/parameters/omit-xml-declaration/yes")
  %output:omit-xml-declaration("yes")
function omit-xml-declaration-yes() {
  <e>Hello World</e>
};

declare
  %rest:path("/response/serialization/parameters/omit-xml-declaration/no")
  %output:omit-xml-declaration("no")
function omit-xml-declaration-no() {
  <e>Hello World</e>
};

declare
  %rest:path("/response/serialization/parameters/omit-xml-declaration/multi")
  %output:omit-xml-declaration("no")
function omit-xml-declaration-multi() {
  (: only 1 XML Declaration, even if there are 2 or more nodes :)
  <e>A</e>, <e>B</e>
};

declare
  %rest:path("/response/serialization/parameters/standalone/yes")
  %output:standalone("yes")
  %output:omit-xml-declaration("no")
function standalone-yes() {
  <e>Hello World</e>
};

declare
  %rest:path("/response/serialization/parameters/standalone/no")
  %output:standalone("no")
  %output:omit-xml-declaration("no")
function standalone-no() {
  <e>Hello World</e>
};

declare
  %rest:path("/response/serialization/parameters/supress-indentation")
  %output:supress-indentation("yes")
function supress-indentation() {
  "not supported in this version"
};

declare
  %rest:path("/response/serialization/parameters/undeclare-prefixes")
  %output:undeclare-prefixes("yes")
function undeclare-prefixes() {
  "not supported in this version"
};

declare
  %rest:path("/response/serialization/parameters/version")
  %output:version("1.0")
function version() {
  "not supported in this version"
};
