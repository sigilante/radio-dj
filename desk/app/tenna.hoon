/-  store=radio
/+  radio, vita-client
/+  default-agent, dbug, verb, agentio
=,  format
:: ::
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
  ==
+$  state-0
  $:  %0
      tune=(unit ship)
      wack=_|
  ==
+$  state-1
  $:  %1
      tune=(unit ship)
      spin-history=(set cord)
  ==
+$  state-2
  $:  %2
      tune=(unit ship)
      spin-history=(set cord)
      =spin:radio
      chatlog=(list chat:radio)
      viewers=(set ship)
  ==
+$  card     card:agent:gall
--
=|  state-2
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
::
++  on-fail   on-fail:def
++  on-peek   on-peek:def
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  :: special case for state-0 because
  :: I changed the state without
  :: writing a proper on-load
  ?.  ?=(^ +.old-state)  !!
  ?:  =(%0 +<.old-state)
    :: one last hard nuke for state-0
    `this
  ::
  :: regular support for further upgrades
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state [%2 tune *(set cord) *spin:radio *(list chat:store) *(set ship)])
    %1  `this(state [%2 tune spin-history *spin:radio *(list chat:store) *(set ship)])
    %2  `this
  ==
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  `this
++  on-save
  ^-  vase
  !>(state)
++  on-init
  ^-  (quip card _this)
  `this
++  on-leave
  |=  [=path]
  `this
  ::
  ::  actually... this breaks everything
  ::
  :: :_  this
  :: ::
  :: :: this is another layer of protection to clear out stale viewers
  :: :: poke yourself to tune out
  :: :~
  ::   %+  poke:pass:agentio
  ::     [our.bowl %tenna]
  ::     :-  %radio-action
  ::     !>  [%tune ~]
  :: ==
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
                            ~&  act
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
                ~&  act

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
  ?+  mark  (on-poke:def mark vase)
      %noun
    `this
    ::
    :: :: radio
      %radio-action
    ?.  =(src.bowl our.bowl)
      `this
    =/  act  !<(action:store vase)
    ?-    -.act
        %online         `this
        %permissions    `this
        %viewers
      :_  this
      :~  :*  %give  %fact  ~[/viewers]
              %noun
              !>(`viewers-update:store`act)
      ==  ==
        %chatlog
      :_  this
      :~  :*  %give  %fact  ~[/chatlog]
              %noun
              !>(`chatlog-update:store`act)
      ==  ==
      ::
        %tower-update   `this
      ::
        %delete-chat    [(fwd act) this]
      ::
        %presence       [(fwd act) this]
      ::
        %spin
      :_  this
      :-  :*  %give  %fact  ~[/spin]
                %noun
                !>(`spin-update:store`act)
            :: ==
            :: :*  %give  %fact  ~[/spin-history]
            ::     %noun
            ::     !>(`spin-history-update:store`spin-history)
          ==
      (fwd act)
      ::
        %talk           [(fwd act) this]
        %chat           [(fwd act) this]
        %description    [(fwd act) this]
      ::
        %tune
      =*  new-tune  tune.act
      =/  old-tune  tune
      =.  tune  new-tune
      =/  watt  (watch:hc new-tune)
      =/  love  (leave:hc old-tune)
      [(weld love watt) this]
    ==
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ~&  >>  [src.bowl path]
  ?+    path
    (on-watch:def path)
      [%frontend ~]
    :_  this
    :~  (active:vita-client bowl)
    ==
    ::
      [%spin ~]
    :_  this
    :~  :*  %give  %fact  ~
            %noun
            !>(`spin-update:store`[%spin spin])
    ==  ==
    ::
      [%tune ~]
    :_  this
    :~  :*  %give  %fact  ~
            %noun
            !>(`tune-update:store`[%tune tune])
    ==  ==
    ::
      [%spin-history ~]
    :_  this
    :~  :*  %give  %fact  ~
            %noun
            !>(`spin-history-update:store`[%spin-history spin-history])
    ==  ==
    ::
      [%chatlog ~]
    :_  this
    :~  :*  %give  %fact  ~
            %noun
            !>(`chatlog-update:store`[%chatlog chatlog])
    ==  ==
    ::
      [%viewers ~]
    :_  this
    :~  :*  %give  %fact  ~
            %noun
            !>(`viewers-update:store`[%viewers viewers])
    ==  ==
  ==
--
:: ::
:: :: helper core
:: ::
|_  bowl=bowl:gall
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
  :: ?~  old-tune  ~
  :: :~
  :: [%pass (global-wire u.old-tune) %agent [u.old-tune provider] %leave ~]
  :: [%pass (personal-wire u.old-tune) %agent [u.old-tune provider] %leave ~]
  :: ==
++  watch
  |=  new-tune=(unit ship)
  ^-  (list card)
  ?~  new-tune
    :~
      (fact:agentio tuneout ~[/frontend])
      :*  %give  %fact  ~
          %noun
          !>(`tune-update:store`[%tune (need new-tune)])
      ==  
    ==
  :~
    [%pass (global-wire u.new-tune) %agent [u.new-tune provider] %watch /global]
    [%pass (personal-wire u.new-tune) %agent [u.new-tune provider] %watch /personal]
    :*  %give  %fact  ~[/tune]
      %noun
      !>(`tune-update:store`[%tune new-tune])
    ==
  ==
++  fwd
  |=  [act=action:store]
  ?~  tune.state  ~
  :~
    %+  poke:pass:agentio
      [(need tune.state) provider]
      :-  %radio-action
      !>  act
  ==
++  tuneout
  radio-action+!>([%tune ~])
-- 

