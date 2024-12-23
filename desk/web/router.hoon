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
  =/  url  (crip "/apps/radio{path}")
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
    %-  layout
    :~  ?+  p  manx-bail
          [%tuner ~]           serve-root
          [%tuner %tune ~]     serve-tune
          [%tuner %chat ~]     serve-chatlog
          [%tuner %viewers ~]  serve-viewers
          [%tuner %sync ~]     serve-sync
          [%tuner %f %sigil ~]    serve-sigil
    ==  ==
    ::
    ++  yt-embed
      |=  =tape
      ^-  ^tape
      %-  fall  :_  "https://www.youtube.com/embed/YQHsXMglC9A"
      %-  mole
      |.
      ?~  (find "youtu.be" tape)
        ::  style https://www.youtube.com/watch?v=YQHsXMglC9A
        ;:  weld
          (scag (need (find "watch?v=" tape)) tape)
          "embed/"
          (swag [(add 8 (need (find "watch?v=" tape))) 11] tape)
        ==
      ::  style https://youtu.be/XGC80iRS7tw
      ;:  weld
        "https://youtube.com/embed/"
        (slag (add 8 (need (find "youtu.be" tape))) tape)
      ==
    ++  yt-timestamp
      |=  d=@da

      ^-  tape
      %+  welp  "start="
      %-  a-co:co
      s:(yell (sub now.bowl d))
      ::
    ++  serve-root
      ^-  manx
      ~&  >>>  (trip url.spin.state)
      ~&  >>>  (yt-embed (trip url.spin.state))
      ;div
        ;+  navbar
        ;div.fc.hf
          ;main.fr.grow
            ;div.grow.fc.basis-half
              ;iframe.grow
                =frameborder  "0"
                =allow  "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                =allowfullscreen  ""
                =src  "{(yt-embed (trip url.spin.state))}?{(yt-timestamp start-time.spin.state)}"
                ;
              ==
            ;div.fc
              ;div.fr.ac.jb.p2
                ;span: 1 viewer
                ;span.underline: help
              ==
              ;div: watching {(scow %p (fall tune.state ~zod))}
            ==
          ==
          ;div.grow.b2.fc(style "min-width: 200px;")
            ;div.grow
              ;*  (turn chatlog:state chat-to-manx)
            ==
            ;form.fr
              =method  "post"
              =action  "/apps/tuner/chat/blah"
              ;input.p-1.mono.grow
                =type  "text"
                =name  "message"
                =placeholder  "message"
                ;
              ==
              ;button.p-1.b1.hover(type "submit"): send
              ==
            ==
          ==
        ==
      ==
    ::
    ++  navbar
      ^-  manx
      ;nav#topnav.fs.g2
        ;div.f.g2
          ;div#nav-links
            ;a/"https://urbit.org":"~Urbit"
            ;a.active/"https://urbit.org/ecosystem/apps/radio":"Radio"
          ==
        ==
        ;div#login-div
          ;+  login-prompt
        ==
        ;script:"{script}"
      ==
    ::
    ++  login-prompt
      ^-  manx
      ;a/"/tuner/log":"Log In"
    ::
    ++  script
      ^~
      %-  trip
'''
  async function setSigil(){
    console.log("setting sigil")
    const div = document.getElementById("login-div");
    const res = await fetch("/tuner/f/sigil");
    const t = await res.text();
    console.log("sigil", t);
    if (t) div.innerHTML = t;
  }  
  setSigil();
'''
    ::
    ++  serve-sigil
      ^-  manx
      ?-  (clan:title src.bowl)
        %czar  sigil
        %king  sigil
        %duke  sigil
        %earl  sigil
        %pawn  login-prompt
      ==
    ::
    ++  sigil
      ^-  manx
      =/  ship  src.bowl
      =/  p  (scow %p ship)
        ;div.f.g2
          ;p:"{p}"
          ;+  ;a/"/tuner/logout":"Log Out"
        ==
    ::
    ++  serve-tune
      ^-  manx
      ;/  (scow %p (need tune.state))
    ::
    ++  chat-to-manx
      |=  =chat:radio
      ^-  manx
      ;div
        ;strong: {(scow %p from.chat)}
        ;span: {(trip message.chat)}
      ==
    ++  serve-chatlog
      ^-  manx
      |^
      ;div
        ;*  (turn chatlog:state chat-to-manx)
      ==
      --
    ::
    ++  serve-viewers
      ^-  manx
      ;/  (scow %ud ~(wyt in viewers.state))
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
  ++  enjs-challenge
    =,  enjs:format
    |=  chal=@
    ^-  json
    %-  pairs
    :~  [%challenge [%s (scot %uv chal)]]
    ==
  ++  self-poke
    |=  noun=*
    ^-  (list card:agent:gall)
    :~  [%pass /gib %agent [our.bowl dap.bowl] %poke %noun !>(noun)]
    ==
  --
--
