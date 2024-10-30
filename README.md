# radio

**Status ~2024.10.30.  Mirrored tower state to tenna to make it easier to communicate to tuner.**

Needs:

- [x] handle %watch subs & updates
- [x] make the actual page builder
- [/] fix subscription/state mismatches
- [ ] finish navbar
- [ ] handle MetaMask auth/button
- [ ] show default page for !authenticated.req.order

watch videos and listen to music with your friends on urbit.

viewing parties, audio/video curation, scheduled broadcasting, or just hanging out.

## Desk

there are two agents: tower and tenna.

`%tenna` manages a single subscription to a remote tower configurable from the UI.

`%tower` stores a configurable url+timestamp for media and relays chat messages to all subscribers.

`%tuner` provides a static tuned-in station with chatbox to arbitrary observers who log in with an Urbit id

- access a broadcasting ship at its url `https://my.ship/apps/tuner`
- currently (~2024.10.16) chat messages are not yet supported pending auth
- maybe add [this](https://github.com/urbit/urbit/blob/01afc2a143fcfb24904a6d64ee124d68307fac2c/pkg/arvo/app/weather.hoon)

## UI

the radio frontend uses the react-player npm library to play media based on a url+timestamp.

every radio station has its own chatroom. to interact with radio, users type commands into chat.

the tuner frontend is served using sail
