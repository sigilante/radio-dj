/-  store=radio
/-  *tuner
/+  radio, vita-client
/+  server
/+  default-agent, dbug, verb, agentio
/=  layout  /web/layout
/=  router  /web/router
=,  format
:: ::
|%
+$  card     card:agent:gall
--
=|  state-0
=*  state  -
^-  agent:gall
%-  %-  agent:vita-client
      [& ~nodmyn-dosrux]
%+  verb  |
%-  agent:dbug
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> bowl)
    io    ~(. agentio bowl)
    rout  ~(. router:router [state bowl])
::
++  on-fail   on-fail:def
++  on-peek   on-peek:def
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
      %0  [[%pass /root %arvo %e %connect [~ /apps/tuner] dap.bowl]~ this]
  ==
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  [(list card) _this]
  ?+    sign-arvo  ~|([%strange-sign-arvo -.sign-arvo] !!)
      [%eyre %bound *]
    ~&  >  '%tuner: %eyre bound endpoints'
    [~ this]
  ==
++  on-save
  ^-  vase
  !>(state)
++  on-init
  ^-  (quip card _this)
  =.  tune.state  `our.bowl
  :_  this
  :~  [%pass /root %arvo %e %connect [~ /apps/tuner] dap.bowl]
      :*  %pass
          /tune/(scot %da now.bowl)  %agent
          [(need tune.state) %tenna]
          %watch  /tune
      ==
      :*  %pass
          /spin/(scot %da now.bowl)  %agent
          [(need tune.state) %tower]
          %watch  /spin
      ==
      :*  %pass
          /spin-history/(scot %da now.bowl)  %agent
          [(need tune.state) %tenna]
          %watch  /spin-history
      ==
      :*  %pass
          /chatlog/(scot %da now.bowl)  %agent
          [(need tune.state) %tower]
          %watch  /chatlog
      ==
      :*  %pass
          /viewers/(scot %da now.bowl)  %agent
          [(need tune.state) %tower]
          %watch  /viewers
  ==  ==
++  on-leave
  |=  [=path]
  `this
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?~  tune.state  `this
  ?.  =(src.bowl (need tune.state))
    `this
  ?+    wire  (on-agent:def wire sign)
      [%radio @ %personal ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %radio-action
        =/  to-frontend  (fact:io cage.sign ~[/frontend])
        =/  act  !<(action:store q.cage.sign)
        ?+  -.act  [[to-frontend ~] this]
            %spin
          =.  spin-history
            (~(put in spin-history) url.act)
          [[to-frontend ~] this]
            %tower-update
          :_  this
          =/  tune-act
            :-  %radio-action
            !>([%tune `src.bowl])
          :~
            to-frontend
            (fact:io tune-act ~[/frontend])
          ==
        ==
      ==
    ==
      [%radio @ %global ~]
    ?+    -.sign  (on-agent:def wire sign)
        %kick
      :_  this
      :~
      (poke-self:pass:io tuneout)
      ==
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %radio-action
        :: WET: write everything twice!
        :: the same exact code as /personal
        :: intentionally violating DRY in favor of WET
        =/  act  !<(action:store q.cage.sign)
        =/  to-frontend  (fact:io cage.sign ~[/frontend])
        ?+  -.act  [[to-frontend ~] this]
            %spin
          =.  spin-history
            (~(put in spin-history) url.act)
          [[to-frontend ~] this]
        ==
        :: /WET
      ==
    ==
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?:  ?=([%meta @t] q.vase)
      =^  cards  state
        (handle-meta:hc +.q.vase)
      [cards this]
    ?:  ?=([%auth @p @p @uv] q.vase)
      =^  cards  state
        (handle-auth:hc +.q.vase)
      [cards this]
    `this
    ::
      %handle-http-request
    =/  order  !<(order:router vase)
    ?:  =('GET' method.request.req.order)
      [(eyre:rout order) this]
    =^  cards  state
      (handle-post:hc order)
    [cards this]
    ::
      %radio-action
    ?.  =(src.bowl our.bowl)  `this
    =/  act  !<(action:store vase)
    ?-  -.act
      %online        `this
      %permissions   `this
      %viewers       `this
      %chatlog       `this
      %tower-update  `this
      %delete-chat   `this
      %presence      :_  this  (fwd act)
      %spin          `this
      %talk          :_  this  (fwd act)
      %chat          :_  this  (fwd act)
      %description   `this
      %tune          `this
    ==
  ==
++  on-watch
  |=  =(pole knot)
  ?+  pole  !!
    [%http-response id=@ ~]    [~ this]
  ==
--
::
:: helper core
::
|_  bowl=bowl:gall
+*  that  state
++  provider  %tower
++  personal-wire
  |=  =ship
  ^-  wire
  [%radio (scot %p ship) %personal ~]
++  global-wire
  |=  =ship
  ^-  wire
  [%radio (scot %p ship) %global ~]
++  leave-all-wex
  ^-  (list card)
  %+  turn  ~(tap in ~(key by wex.bowl))
  |=  [=wire =ship =term]
  [%pass wire %agent [ship term] %leave ~]
++  leave
  |=  old-tune=(unit ship)
  ^-  (list card)
  leave-all-wex
++  watch
  |=  new-tune=(unit ship)
  ^-  (list card)
  ?~  new-tune
    :~  (fact:agentio tuneout ~[/frontend])
    ==
  :~  [%pass (global-wire u.new-tune) %agent [u.new-tune provider] %watch /global]
      [%pass (personal-wire u.new-tune) %agent [u.new-tune provider] %watch /personal]
  ==
++  fwd
  |=  [act=action:store]
  ?~  tune.state  ~
  :~  %+  poke:pass:agentio
        [(need tune.state) provider]
      :-  %radio-action
      !>  act
  ==
++  tuneout
  radio-action+!>([%tune ~])
::
++  handle-post
  |=  =order:router
  ^-  (quip card _that)
  |^
  =/  rl  (parse-request-line:server url.request.req.order)
  =/  p=(pole knot)  site.rl
  ?+  p  [~ that]
    [%chat msg=@t ~]  [(handle-chat msg.p) that]
  ==
  ++  handle-chat
    |=  msg=@t
    ^-  (list card)
    :~  :*  %pass
            /chat/[(scot %da now.bowl)]  %agent
            [(need tune.state) %tower]
            %poke  [%radio-action !>([%chat msg])]
    ==  ==
  --
::  MetaMask authentication successful.
::  Normally called only via self-poke from 'POST'.
++  handle-meta
  |=  new-challenge=@
  =?    sessions
      !(~(has by sessions) src.bowl)
    (~(put by sessions) [src.bowl src.bowl])
  =.  last-challenge  `new-challenge
  =?    challenges
      =(src.bowl (~(got by sessions) src.bowl))
    (~(put in challenges) new-challenge)
  `that
++  handle-auth
  |=  [who=@p src=@p secret=@uv]
  ^-  [(list card) _that]
  ~&  >  "%ustj: Successful authentication of {<src>} as {<who>}."
  :-  ~
  %=  that
    sessions        (~(put by sessions) src who)
    challenges      (~(del in challenges) secret)
    last-challenge  ?:(=(last-challenge `secret) ~ last-challenge)
  ==
-- 

