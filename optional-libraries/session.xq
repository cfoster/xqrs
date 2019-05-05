(:
 : Session Module
 :
 : This is a working example of how to perform application level authentication
 : with XQRS. You are free to change how this works to suit your needs.
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

module namespace session = "http://xmllondon.com/xquery/session";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace http = "http://expath.org/ns/http-client";

declare option xdmp:mapping "true";

declare
  %rest:path("/session/login")
  %xdmp:tx-boundary
  %rest:POST("{$body}")
function login($body as document-node()) as element(rest:response) {
  <rest:response>{
    if(xdmp:login(
      $body/node()/(name|user|username)[1],
      $body/node()/(password|pass)[1],
      $body/node()/set-session,
      $body//role
    )) then
      <http:response status="200" message="Login successful"/>
    else
      <http:response status="401" message="Unauthorized"/>
  }</rest:response>
};

declare
  %rest:path("/session/status")
  %rest:produces("text/xml", "application/xml", "*/*")
  %xdmp:tx-boundary
function status-xml() {
  element info {
    element user { xdmp:get-current-user() },
    if(has-privilege("xdmp-user-roles")) then
      element roles {
        roles() ! element role { . }
      }
    else ()
  }
};

declare
  %rest:path("/session/status")
  %rest:produces("application/json", "text/json")
  %xdmp:tx-boundary
function status-json() {
  object-node {
    "user" : xdmp:get-current-user(),
    "role" : array-node {
      if(has-privilege("xdmp-user-roles")) then roles() else () 
    }
  }
};

declare
  %rest:path("/session/logout")
  %xdmp:tx-boundary
function logout() {
  xdmp:logout()  
};

declare %private function roles() as xs:string* {
  xdmp:role-name(xdmp:user-roles(xdmp:get-request-username()))
};

declare %private function has-privilege($priv as xs:string) as xs:boolean {
  xdmp:has-privilege("http://marklogic.com/xdmp/privileges/" || $priv,
                     "execute")
};