module namespace response-format =
  "/spec/response/response-format";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace http = "http://expath.org/ns/http-client";

declare
  %rest:path("/response/response-format/empty-sequence")
function empty-seq() as empty-sequence() {
  ()
};

declare
  %rest:path("/response/response-format/{$code}/{$message}")
function s1(
  $code as xs:integer,
  $message as xs:string) as element(rest:response) {
  <rest:response>
    <http:response status="{$code}" message="{$message}">
      <http:header name="X-A" value="Value 1"/>
      <http:header name="X-B" value="Value 2"/>
      <http:header name="X-C" value="Value 3"/>
    </http:response>
  </rest:response>
};

declare
  %rest:path("/response/response-format-doc/{$code}/{$message}")
function s2(
  $code as xs:integer,
  $message as xs:string) as document-node(element(rest:response)) {
  document {
    <rest:response>
      <http:response status="{$code}" message="{$message}">
        <http:header name="X-A" value="Value 1"/>
        <http:header name="X-B" value="Value 2"/>
        <http:header name="X-C" value="Value 3"/>
      </http:response>
    </rest:response>
  }
};

declare
  %rest:path("/response/response-format/with-content/text")
  %rest:method("text")
function with-content-text() {
  <rest:response>
    <http:response status="404" message="Resource has gone out">
      <http:header name="X-A" value="Value 1"/>
    </http:response>
  </rest:response>,
  "Come back later",
  "Might be back then."
};

declare
  %rest:path("/response/response-format/with-content/xml")
  %rest:method("xml")
function with-content-xml() {
  <rest:response>
    <http:response status="404" message="Resource has gone out">
      <http:header name="X-A" value="Value 1"/>
    </http:response>
  </rest:response>,
  <message>Come back later. Might be back then.</message>
};
