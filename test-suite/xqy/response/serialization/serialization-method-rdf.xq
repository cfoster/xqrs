module namespace serialization-method-rdf =
  "/spec/response/serialization/method/rdf";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare variable $triples as sem:triple* :=
  sem:triple(sem:iri('http://a'), sem:iri('http://b'), sem:iri('http://c')),
  sem:triple(sem:iri('http://x'), sem:iri('http://y'), sem:iri('http://z'));
  
declare variable $query := 'SELECT * WHERE { ?a ?b ?c } LIMIT 2'; 
  
declare
  %rest:path("/response/serialization/method/default")
function default-rdf-auto() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/n-triples")
  %output:method("ntriple")
function n-triples() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/n-quads")
  %output:method("nquad")
function n-quads() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/turtle")
  %output:method("turtle")
function turtle() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/rdf/xml")
  %output:method("rdfxml")
function rdf-xml() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/notation3")
  %output:method("n3")
function Notation3() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/trig")
  %output:method("trig")
function TriG() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/rdf/json")
  %output:method("rdfjson")
function rdf-json() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/triple/xml")
  %output:method("triplexml")
function triple-xml() as sem:triple* {
  $triples
};

declare
  %rest:path("/response/serialization/method/sparql-results/xml")
  %output:method("sparql-results-xml")
function sparql-results-xml() {
  sem:sparql($query, (), (), sem:in-memory-store($triples))
};

declare
  %rest:path("/response/serialization/method/sparql-results/json")
  %output:method("sparql-results-json")
function sparql-results-json() {
  sem:sparql($query, (), (), sem:in-memory-store($triples))
};

declare
  %rest:path("/response/serialization/method/sparql-results/csv")
  %output:method("sparql-results-csv")
function sparql-results-csv() {
  sem:sparql($query, (), (), sem:in-memory-store($triples))
};


