import React, { FC } from 'react';
import store from './app/store';
import { Radio } from './lib';
import {
  setTalkMsg,
  setSpinUrl,
  setSpinTime,
  setTunePatP,
  setIsPublic,
  setHasPublishedStation,
  setViewers,
  resetChats,
  setChatsWithChatlog,
  setChatsWithChat,
  setOurTowerDescription
} from './features/station/stationSlice';
import {
  setUserInteracted,
  setPlayerReady,
  setNavigationOpen,
  setPlayerInSync
} from './features/ui/uiSlice';

import {isValidPatp} from 'urbit-ob';
import ReactPlayer from 'react-player';

export function handleUpdate(update: any, radio: Radio, dispatch: any, userInteracted: boolean) {
  console.log("radio update", update);
  let mark = Object.keys(update)[0];

  // handle updates from tower / radio station
  switch (mark) {
    case 'spin':
      var updateSpin = update['spin'];

      dispatch(setSpinUrl(updateSpin.url));
      dispatch(setSpinTime(updateSpin.time));
      break;
    case 'talk':
      // let synth = window.speechSynthesis;
      var updateTalk = update['talk'];
      var utterThis = new SpeechSynthesisUtterance(updateTalk);

      dispatch(setTalkMsg(updateTalk));

      if (!userInteracted) return;
      radio.synth.speak(utterThis);
      break;
    case 'tune':
      let tune = update['tune'];
      dispatch(setTunePatP(tune));
      // radio.tunedTo = tune;
      if (tune === null) {
        resetPage(dispatch);
        dispatch(setUserInteracted(false));
        // radio.tune(our)
        // alert('whoops, you left the radio station')
      } else {
        radio.ping();
      }
      break;
    case 'chat':
      let chat = update['chat'];
      dispatch(setChatsWithChat(chat));
      // lol
       if(chat.message==='BRAP') {
         let audio = new Audio(radio.soundUrls.fart)
         audio.play()
       }
      break;
    case 'viewers':
      let viewers = update['viewers'];
      /*
      if(radio.tunedTo === radio.our) {
        // TODO finish this and make it toggleable
        // play a sound for new viewers
        // (if we're the host)
        let audio = new Audio(radio.soundUrls.orb)
        audio.play()
      }
      */
      dispatch(setViewers(viewers));
      break;
    case 'public':
      dispatch(setIsPublic(update['public']))
      break;
    case 'chatlog':
      let chatlog = update['chatlog']
      dispatch(setChatsWithChatlog(chatlog));
  }
};

export function resetPage(dispatch: any) {
  dispatch(setPlayerReady(false));
  dispatch(resetChats());
  dispatch(setTalkMsg(''));
  dispatch(setViewers([]));
  dispatch(setSpinUrl(''));
  dispatch(setNavigationOpen(false));
}

// TODO clean this up
export function handleUserInput(
  radio: Radio,
  dispatch: any,
  chatInputId: string,
  spinTime: number,
  spinUrl: string,
  tunePatP: string,
) {
  let input = document.getElementById(chatInputId) as HTMLInputElement;
  // @ts-ignore
  let player:any = !window.playerRef ? null : window.playerRef.current

  let chat = input.value;
  input.value = '';

  if (chat === '') return;

  // check for commands
  let got = getCommandArg(chat);
  if (!got) {
    // just a regular chat message
    radio.chat(chat);
    return;
  }

  // interpreting message as a command
  let command = got.command;
  let arg = got.arg;
  switch (command) {
    case 'talk':
      radio.chat(chat);
      radio.talk(arg);
      break;
    case 'play':
      radio.spin(arg);
      radio.chat(chat);
      break;
    case 'tune':
      if (arg === '') arg = radio.our;
      radio.chat(chat);
      if(isValidPatp(arg)) {
        radio.tuneTo(dispatch, arg);
      }
      else if(isValidPatp('~'+arg)) {
        radio.tuneTo(dispatch, '~'+arg);
      }
      break;
    case 'time':
      dispatch(setPlayerInSync(true));
      radio.seekToGlobal(player, spinTime);
      radio.chat(chat);
      break;
    case 'set-time':
      // if(!radio.isAdmin())) {
      //   return;
      // }
      radio.resyncAll(player, tunePatP, spinUrl);
      radio.chat(chat);
      break;
    case 'public':
      if(!radio.isAdmin(tunePatP)) {
        return;
      }
      radio.public();
      radio.chat(chat);
      break;
    case 'private':
      if(!radio.isAdmin(tunePatP)) {
        return;
      }
      radio.private();
      radio.chat(chat);
      break;
    case 'ban':
      if(!radio.isAdmin(tunePatP)) {
        return;
      }
      radio.ban(arg);
      radio.chat(chat);
      break;
    case 'unban':
      if(!radio.isAdmin(tunePatP)) {
        return;
      }
      radio.unban(arg);
      radio.chat(chat);
      break;
    case 'ping':
      radio.ping();
      // radio.chat(chat);
      break;
    case 'logout':
      radio.tune(null);
      break;
    case 'live':
      radio.syncLive(player, tunePatP, spinUrl);
      radio.chat(chat);
      break;
    case 'publish':
      if (!radio.isAdmin(tunePatP)) {
        return;
      }
      radio.gregPut(arg);
      radio.chat(chat);
      dispatch(setHasPublishedStation(true));
      dispatch(setOurTowerDescription(arg))
      // refresh towers
      radio.gregRequest();
      break;
    case 'qpublish':
      if (!radio.isAdmin(tunePatP)) {
        return;
      }
      radio.gregPut(arg);
      dispatch(setHasPublishedStation(true));
      dispatch(setOurTowerDescription(arg))
      // refresh towers
      radio.gregRequest();
    //
    // image commands
    default:
      radio.chatImage(command);
      break;
    //
  }
}

  // parse from user input
function getCommandArg(chat: string) {
  // if(!(chat[0] === '!' || chat[0] === '|' || chat[0] === '+' || chat[0] === ':')) return;
  if (!(chat[0] === '!')) return;

  let splitIdx = chat.indexOf(' ');
  if (splitIdx === -1) return {'command': chat.slice(1), 'arg': ''};
  let command = chat.slice(1, splitIdx);
  let arg = chat.slice(splitIdx + 1);
  return {'command': command, 'arg': arg};
}
