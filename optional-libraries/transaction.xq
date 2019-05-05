(:
 : XQRS Transaction Module
 :
 : Version: 1.0
 : Author: Charles Foster
 :  
 : Copyright 2019 XML London Limited. All rights reserved.
 :  
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :  
 :     http://www.apache.org/licenses/LICENSE-2.0
 :  
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

module namespace tx = "http://xmllondon.com/xquery/transaction";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace http = "http://expath.org/ns/http-client";

declare
  %rest:path("/transaction/start")
  %xdmp:tx-boundary
function start() as element(rest:response)
{
  start(create("update"))
};

declare
  %rest:path("/transaction/start-read-only")
  %xdmp:tx-boundary
function start-read-only() as element(rest:response)
{
  start(create("query"))
};

declare
  %rest:path('/transaction/commit')
  %rest:cookie-param("XQRS-Session-ID", "{$tx}")
  %xdmp:tx-boundary
function commit($tx as xs:unsignedLong) as element(rest:response)
{
  commit-impl($tx),
  complete($tx, "Transaction Committed")
};

declare
  %rest:path('/transaction/rollback')
  %rest:cookie-param("XQRS-Session-ID", "{$tx}")
  %xdmp:tx-boundary
function rollback($tx as xs:unsignedLong) as element(rest:response)
{
  rollback-impl($tx),
  complete($tx, "Transaction Rollback")
};

declare
  %rest:path('/transaction/get-transaction-mode')
function get-transaction-mode()
{
  xdmp:get-transaction-mode()
};

declare %private function start($tx as xs:unsignedLong) {
  <rest:response>
    <http:response status="303" message="See Created Transaction">
      <http:header name="Location" value="{'/transaction/' || $tx}"/>
      <http:header name="X-Transaction" value="{$tx}"/>
      <http:header name="Set-Cookie"
                   value="XQRS-Session-ID={$tx}; Path=/; Max-Age=600"/>
    </http:response>
  </rest:response>
};

declare %private function complete(
  $tx as xs:unsignedLong,
  $message as xs:string) {
  <rest:response>
    <http:response status="200" message="{$message}">
      <http:header name="Set-Cookie"
                   value="XQRS-Session-ID={$tx};path=/;max-age=0"/>
    </http:response>
  </rest:response>
};

declare %private function create($type as xs:string) as xs:unsignedLong {
  create($type, ())
};

declare %private function create(
  $type as xs:string,
  $time-limit as xs:unsignedInt?) as xs:unsignedLong {
  let $host := xdmp:host()
  let $tx := xdmp:transaction-create(
               map:new(map:entry("transactionMode", $type)))
  return (
    xdmp:set-transaction-name("xqrs-transaction", $host, $tx),
    if($time-limit) then
      xdmp:set-transaction-time-limit($time-limit, $host, $tx)
    else (),
    $tx
  )
};

declare %private function rollback-impl($tx as xs:unsignedLong) {
  xdmp:transaction-rollback(xdmp:host(), $tx)
};

declare %private function commit-impl($tx as xs:unsignedLong) {
  (: xdmp:xa-complete1(xdmp:host(), $tx, true()) :)
  xdmp:transaction-commit(xdmp:host(), $tx)
};