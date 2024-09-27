/-  sur=tuner, radio
/+  lib=radio, rd=rudder, naive, ethereum
/+  server
::  pages and components
/=  layout        /web/layout
:: /=  chatbox       /web/components/chatbox
::  assets
/*  css       %css    /web/assets/style/css
/*  favicon   %noun   /web/assets/favicon/png
::
|%
+$  order  [id=@ta req=inbound-request:eyre]
++  pbail
  %-  html-response:gen:server
  %-  manx-to-octs:server
      manx-bail
++  manx-bail  ^-  manx  ;div:"404"
++  manx-payload
  |=  =manx
  ^-  simple-payload:http
  %-  html-response:gen:server
  %-  manx-to-octs:server  manx
++  redirect  |=  [eyre-id=@ta path=tape]
  =/  url  (crip "{base-url:cons}{path}")
  =/  pl  (redirect:gen:server url)
  (give-simple-payload:app:server eyre-id pl)
::  main
++  router
  |_  [state=state-0:sur =bowl:gall]
  ++  eyre
    |=  =order
    ^-  (list card:agent:gall)
    =/  rl  (parse-request-line:server url.request.req.order)
    =.  site.rl  ?~  site.rl  ~  t.site.rl
    =/  met  method.request.req.order
    =/  fpath=(pole knot)  [met site.rl]
    ~&  >>  order
    ~&  >>>  fpath
    |^
    :: if file extension assume its asset
    ?.  ?=(~ ext.rl)     (eyre-give (serve-assets rl))
    ?+    fpath  bail
        [%'GET' %metamask rest=*]  (handle-metamask order)
        [%'GET' rest=*]
      (eyre-manx (serve-get rl(site rest.fpath)))
    ==
    ::
    ++  bail  (eyre-give pbail)
    ++  eyre-give
      |=  pl=simple-payload:http
      ^-  (list card:agent:gall)
      (give-simple-payload:app:server id.order pl)

    ++  eyre-manx
      |=  =manx
      %-  eyre-give
      %-  html-response:gen:server
      %-  manx-to-octs:server  manx
    --
  ::
  ++  serve-assets
    |=  rl=request-line:server
    ?+  [site ext]:rl  pbail
      [[%style ~] [~ %css]]  (css-response:gen:server (as-octs:mimes:html css))
    ==
  ++  serve-get
    |=  rl=request-line:server
    ^-  manx
    |^
    =/  p=(pole knot)  site.rl
    ::
    :: ?:  ?=([%f rest=*] p)  (serve-fragment rest.p)
    %-  add-layout
    ?+  p  manx-bail
      [%tune ~]     serve-tune
      [%chat ~]     serve-chatlog
      [%viewers ~]  serve-viewers
      [%sync ~]     serve-sync
    ==
    ::
    ++  serve-tune
      ^-  manx
      ;/  (scow %p (need tune.state))
    ::
    ++  serve-chatlog
      ^-  manx
      ;*  (turn chatlog:state (cury scow %p))
    ::
    ++  serve-viewers
      ^-  manx
      ;/  (scow %ud ~(wyt by viewers.state))
    ::
    ++  serve-sync
      ^-  manx
      *manx
    --
  ++  handle-metamask
    |=  =order
    ::  special-case MetaMask auth handling
    =/  new-challenge  (sham [now eny]:bowl)
    %+  weld  (self-poke [%meta new-challenge])
    %+  give-simple-payload:app:server
      id.order
    ^-  simple-payload:http
    :-  :-  200
        ~[['Content-Type' 'application/json']]
    `(as-octs:mimes:html (en:json:html (enjs-challenge new-challenge)))
  --
  ++  self-poke
    |=  noun=*
    ^-  (list card:agent:gall)
    :~  [%pass /gib %agent [our.bowl dap.bowl] %poke %noun !>(noun)]
    ==
--
