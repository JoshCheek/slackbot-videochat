import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'
import './index.css'

// pull it from public b/c it's broken on node w/ react
// https://github.com/twilio/twilio-video.js/issues/28
import TwilioVideo from '../public/twilio-video.min.js'

const identity = "??"
const roomName = "??"
const token    = "??"

if (!navigator.webkitGetUserMedia && !navigator.mozGetUserMedia) {
  // No dice
  alert('WebRTC is not available in your browser.');
} else {
  // Lets do it!
  new TwilioVideo.Client(token)
    .connect({to: roomName})
    .then(roomJoined, function(e) { alert(e.toString()) })
}


function roomJoined(room) {
  let participants = [room.localParticipant, ...room.participants]

  // do we put them in the DOM here or do we pass them to react?
  let state = { type: "mediaList", list: participants }
  const dom = ReactDOM.render(
    <App state={state} setFeatured={setFeatured}/>,
    document.getElementById('root')
  )

  room.on('participantConnected', function(participant) {
    // add to participants and rerender
  })

  room.on('participantDisconnected', function (participant) {
    // instead, push this down into media,
    // remove it from our participants list here and then render again
    // participant.media.detach()
  });

  room.on('disconnected', function () {
    // ideally do something nice here, realistically this was supposed to be a 4 hr project
  })

  window.addEventListener('beforeunload', function() {
    // I thiiiiiink this is called when you leave the page, MDN docs don't tell you when unload is called,
    // but they give an example that involves leaving a page:
    // https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onbeforeunload
    //
    // Not sure why we need to disconnect, maybe to differentiate it from an interrupted connection
    // so that the other side dosn't think we might come back?
    room.disconnect()
  })

  function setFeatured(participant) {
    participants.forEach(p => p.featured = false)
    participant.featured = true
    dom.forceUpdate()
  }
}


// maybe something like this:

/*

// -----  error  -----
// that first if statement
{ type: "error", reason: "WebRTC is not available in your browser." }

// eg connection issue
{ type: "error", reason: e.toString() }


// -----  disconnected  -----
{ type: "disconnected" }
room.on('disconnected', function () { ... })


// -----  mediaList  -----
{ type: "mediaList", list: participants }

// media.isMuted, media.isPaused
// room.localParticipant.media.attach('#local-media');
// participant.media.detach() // what would happen if we didn't?
function newParticipant(p) {
  // should also put whether it's local or not
  return { identity: p.identity, media: p.media, connected: true }
}

let participants = room.participants
                       .concat(room.localParticipant)
                       .map(newParticipant)


room.on('participantConnected', p => {
  participants = participants.concat(newParticipant(p))
  // somehow force rerender here
})


// https://facebook.github.io/react/docs/react-component.html#forceupdate
room.on('participantDisconnected', function (p) {
});

// -----  ??  -----
// figure out what this event is, does it mean we're navigating away from the page?
window.addEventListener('beforeunload', function() {
  room.disconnect()
})
*/
