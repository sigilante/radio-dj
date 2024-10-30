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
      %0
        :_  this
        :-  [%pass /root %arvo %e %connect [~ /apps/tuner] dap.bowl]
        init-cards:hc
  ==
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  [(list card) _this]
  ?+    sign-arvo  ~|([%strange-sign-arvo -.sign-arvo] !!)
      [%eyre %bound *]
    [~ this]
  ==
++  on-save
  ^-  vase
  !>(state)
++  on-init
  ^-  (quip card _this)
  =.  tune.state  `our.bowl
  ~&  'init hit'
  :_  this
  :-  [%pass /root %arvo %e %connect [~ /apps/tuner] dap.bowl]
  init-cards:hc
++  on-leave
  |=  [=path]
  `this
++  on-agent
  |=  [wire=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ~&  >>>  [wire]
  ::  change channel if %tenna channel changes
  ?+    wire  `this
      [%tune @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  new-tune  !<(tune-update:store q.cage.sign)
      `this(tune +:new-tune)
    ==
    ::
      [%spin @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  new-spin  !<(spin-update:store q.cage.sign)
      ~&  >  +:new-spin
      ~&  >  q.cage.sign
      `this(spin +:new-spin)
    ==
    ::
      [%spin-history @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  new-spin-history  !<(spin-history-update:store q.cage.sign)
      `this(spin-history +:new-spin-history)
    ==
    ::
      [%chatlog @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  new-chatlog  !<(chatlog-update:store q.cage.sign)
      `this(chatlog +:new-chatlog)
    ==
    ::
      [%viewers @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  new-viewers  !<(viewers-update:store q.cage.sign)
      `this(viewers +:new-viewers)
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
++  init-cards
  =/  tune  our.bowl
  :~
    :*  %pass
        /tune/(scot %da now.bowl)  %agent
        [tune %tenna]
        %watch  /tune
    ==
    :*  %pass
        /spin/(scot %da now.bowl)  %agent
        [tune %tenna]
        %watch  /spin
    ==
    :*  %pass
        /spin-history/(scot %da now.bowl)  %agent
        [tune %tenna]
        %watch  /spin-history
    ==
    :*  %pass
        /chatlog/(scot %da now.bowl)  %agent
        [tune %tenna]
        %watch  /chatlog
    ==
    :*  %pass
        /viewers/(scot %da now.bowl)  %agent
        [tune %tenna]
        %watch  /viewers
    ==  
  ==
++  http-cards
  |=  [id=@ta headers=(list [@t @t]) body=@t]
  =/  rath  [/http-response/[id]]~
  =/  page  (as-octs:mimes:html body)
  =/  status  (slav %ud (~(gut by (malt headers)) 'X-Status' '200'))
  :~
      [%give %fact rath %http-response-header !>([status headers])]
      [%give %fact rath %http-response-data !>(`page)]
      [%give %kick rath ~]
  ==
  ::
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
  ?+      p
        :_  that
        (http-cards id.order ['X-Status' '404']~ 'not found')
      [%apps %tuner %chat msg=@t ~]
    ~&  msg/msg.p
    :_  that
    %+  welp  (handle-chat msg.p)
    %^    http-cards
          id.order
      ~[['X-Status' '303'] ['Location' '/apps/tuner']]
    ''
    ::
      [%apps %tuner %chat msg=@t ~]
    [~ that(sessions (~(del by sessions) src.bowl))]
  ==
  ++  handle-chat
    |=  msg=@t
    ^-  (list card)
    :~  :*  %pass
            /chat/[(scot %da now.bowl)]  %agent
            [(fall tune.state our.bowl) %tower]
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

