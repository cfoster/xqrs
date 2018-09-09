module namespace serialization-defaults =
  "/spec/response/serialization/serialization-defaults";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/response/serialization/defaults/triples")
function triples() as sem:triple* {
  sem:triple(
    sem:iri('http://a'),
    sem:iri('http://b'),
    sem:iri('http://c')
  ),
  sem:triple(
    sem:iri('http://x'),
    sem:iri('http://y'),
    sem:iri('http://z')
  )
};

declare
  %rest:path("/response/serialization/defaults/sequence/multi-data")
function sequence-different-data() as item()+ {
  xs:anyURI('http://www.foo.org'),
  xs:base64Binary('AAAA'),
  xs:boolean('true'),
  xs:byte('1'),
  xs:date('2000-12-31'),
  xs:dateTime('2000-12-31T12:00:00'),
  xs:decimal('1'),
  xs:double('1'),
  xs:ENTITY('AAA'),
  xs:float('1'),
  xs:gDay('---11'),
  xs:gMonth('--11'),
  xs:gMonthDay('--01-01'),
  xs:gYear('2000'),
  xs:gYearMonth('2000-01'),
  xs:hexBinary('AA'),
  xs:ID('AA'),
  xs:IDREF('AA'),
  xs:int('1'),
  xs:integer('1'),
  xs:language('en-US'),
  xs:long('1'),
  xs:Name('AAA'),
  xs:NCName('AAA'),
  xs:negativeInteger('-1'),
  xs:NMTOKEN('AAA'),
  xs:nonNegativeInteger('1'),
  xs:nonPositiveInteger('-1'),
  xs:normalizedString('AAA'),
  xs:positiveInteger('1'),
  xs:QName('AAA'),
  xs:short('1'),
  xs:string('AAA'),
  xs:time('12:12:12'),
  xs:token('AAA'),
  xs:unsignedByte('1'),
  xs:unsignedInt('1'),
  xs:unsignedLong('1'),
  xs:unsignedShort('1'),
  xs:dayTimeDuration('PT5H'),
  xs:untypedAtomic('AAA'),
  xs:yearMonthDuration('P1M'),
  <e a="test-data"/>/@a,
  <!-- comment -->, 
  document{<e/>},
  <e/>, 
  processing-instruction {'a'} {'b'},
  <e>text</e>/text()
};

declare
  %rest:path("/response/serialization/defaults/anyURI")
  function anyURI() as xs:anyURI {
  xs:anyURI('http://www.foo.org')
};

declare
  %rest:path("/response/serialization/defaults/base64Binary")
  function base64Binary() as xs:base64Binary {
  xs:base64Binary('AAAA')
};

declare
  %rest:path("/response/serialization/defaults/boolean")
  function boolean() as xs:boolean {
  xs:boolean('true')
};

declare
  %rest:path("/response/serialization/defaults/byte")
  function byte() as xs:byte {
  xs:byte('1')
};

declare
  %rest:path("/response/serialization/defaults/date")
  function date() as xs:date {
  xs:date('2000-12-31')
};  

declare
  %rest:path("/response/serialization/defaults/dateTime")
  function dateTime() as xs:dateTime* {
  xs:dateTime('2000-12-31T12:00:00')
};

declare
  %rest:path("/response/serialization/defaults/decimal")
  function decimal() as xs:decimal {
  xs:decimal('1')
};

declare
  %rest:path("/response/serialization/defaults/double")
  function double() as xs:double {
  xs:double('1')
};

declare
  %rest:path("/response/serialization/defaults/ENTITY")
  function ENTITY() as xs:ENTITY {
  xs:ENTITY('AAA')
};

declare
  %rest:path("/response/serialization/defaults/float")
  function float() as xs:float {
  xs:float('1')
};

declare
  %rest:path("/response/serialization/defaults/gDay")
  function gDay() as xs:gDay {
  xs:gDay('---11')
};

declare
  %rest:path("/response/serialization/defaults/gMonth")
  function gMonth() as xs:gMonth {
  xs:gMonth('--11')
};

declare
  %rest:path("/response/serialization/defaults/gMonthDay")
  function gMonthDay() as xs:gMonthDay {
  xs:gMonthDay('--01-01')
};

declare
  %rest:path("/response/serialization/defaults/gYear")
  function gYear() as xs:gYear {
  xs:gYear('2000')
};

declare
  %rest:path("/response/serialization/defaults/gYearMonth")
  function gYearMonth() as xs:gYearMonth {
  xs:gYearMonth('2000-01')
};

declare
  %rest:path("/response/serialization/defaults/hexBinary")
  function hexBinary() as xs:hexBinary {
  xs:hexBinary('AA')
};

declare
  %rest:path("/response/serialization/defaults/ID")
  function ID() as xs:ID {
  xs:ID('AA')
};

declare
  %rest:path("/response/serialization/defaults/IDREF")
  function IDREF() as xs:IDREF {
  xs:IDREF('AA')
};

declare
  %rest:path("/response/serialization/defaults/int")
  function int() as xs:int {
  xs:int('1')
};

declare
  %rest:path("/response/serialization/defaults/integer")
  function integer() as xs:integer {
  xs:integer('1')
};

declare
  %rest:path("/response/serialization/defaults/language")
  function language() as xs:language {
  xs:language('en-UK')
};

declare
  %rest:path("/response/serialization/defaults/long")
  function long() as xs:long {
  xs:long('1')
};

declare
  %rest:path("/response/serialization/defaults/Name")
  function Name() as xs:Name {
  xs:Name('AAA')
};

declare
  %rest:path("/response/serialization/defaults/NCName")
  function NCName() as xs:NCName {
  xs:NCName('AAA')
};

declare
  %rest:path("/response/serialization/defaults/negativeInteger")
  function negativeInteger() as xs:negativeInteger {
  xs:negativeInteger('-1')
};

declare
  %rest:path("/response/serialization/defaults/NMTOKEN")
  function NMTOKEN() as xs:NMTOKEN {
  xs:NMTOKEN('AAA')
};

declare
  %rest:path("/response/serialization/defaults/nonNegativeInteger")
  function nonNegativeInteger() as xs:nonNegativeInteger {
  xs:nonNegativeInteger('1')
};

declare
  %rest:path("/response/serialization/defaults/nonPositiveInteger")
  function nonPositiveInteger() as xs:nonPositiveInteger {
  xs:nonPositiveInteger('-1')
};

declare
  %rest:path("/response/serialization/defaults/normalizedString")
  function normalizedString() as xs:normalizedString {
  xs:normalizedString('AAA')
};

declare
  %rest:path("/response/serialization/defaults/positiveInteger")
  function positiveInteger() as xs:positiveInteger {
  xs:positiveInteger('1')
};

declare
  %rest:path("/response/serialization/defaults/QName")
  function QName() as xs:QName {
  xs:QName('AAA')
};

declare
  %rest:path("/response/serialization/defaults/short")
  function short() as xs:short {
  xs:short('1')
};

declare
  %rest:path("/response/serialization/defaults/string")
  function string() as xs:string {
  xs:string('AAA')
};

declare
  %rest:path("/response/serialization/defaults/time")
  function time() as xs:time {
  xs:time('12:12:12')
};

declare
  %rest:path("/response/serialization/defaults/token")
  function token() as xs:token {
  xs:token('AAA')
};

declare
  %rest:path("/response/serialization/defaults/unsignedByte")
  function unsignedByte() as xs:unsignedByte {
  xs:unsignedByte('1')
};

declare
  %rest:path("/response/serialization/defaults/unsignedInt")
  function unsignedInt() as xs:unsignedInt {
  xs:unsignedInt('1')
};

declare
  %rest:path("/response/serialization/defaults/unsignedLong")
  function unsignedLong() as xs:unsignedLong {
  xs:unsignedLong('1')
};

declare
  %rest:path("/response/serialization/defaults/unsignedShort")
  function unsignedShort() as xs:unsignedShort {
  xs:unsignedShort('1')
};

declare
  %rest:path("/response/serialization/defaults/dayTimeDuration")
  function dayTimeDuration() as xs:dayTimeDuration {
  xs:dayTimeDuration('PT5H')
};

declare
  %rest:path("/response/serialization/defaults/untypedAtomic")
  function untypedAtomic() as xs:untypedAtomic {
  xs:untypedAtomic('AAA')
};

declare
  %rest:path("/response/serialization/defaults/yearMonthDuration")
  function yearMonthDuration() as xs:yearMonthDuration {
  xs:yearMonthDuration('P1M')
};

declare
  %rest:path("/response/serialization/defaults/xml-attribute")
  function xml-attribute() as attribute() {
  <e a="test-data"/>/@a
};

declare
  %rest:path("/response/serialization/defaults/xml-comment")
  function xml-comment() as comment() {
  <!-- comment -->
};

declare
  %rest:path("/response/serialization/defaults/xml-document-element")
  function xml-document-element() as document-node(element(e)) {
  document{<e/>}
};

declare
  %rest:path("/response/serialization/defaults/xml-element")
  function xml-element() as element(e)* {
  <e/>
};
 
declare
  %rest:path("/response/serialization/defaults/xml-processing-instruction")
  function xml-processing-instruction() as processing-instruction() {
  processing-instruction {'a'} {'b'}
};

declare
  %rest:path("/response/serialization/defaults/xml-text")
  function xml-text() as text() {
  <e>text</e>/text()
};

