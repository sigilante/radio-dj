/-  radio
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      tune=(unit ship)
      =spin:radio
      spin-history=(set cord)
      chatlog=(list chat:radio)
      viewers=(set ship)
      ::
      sessions=(map comet=ship id=ship)
      challenges=(set @uv)
      last-challenge=(unit @uv)
  ==
--
