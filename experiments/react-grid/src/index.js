import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';

function newMedia(name) {
  // figure out what this thing should look like
  // probably an attach and detach method
  return {
    url: `/${name}.jpg`
  }
}

function newParticipant(id, name) {
  return {
    identity:  id,
    media:     newMedia(name),
    connected: true,
  }
}

let participants = [
  newParticipant(1, 'josh-ren'),
  newParticipant(2, 'josh-pumpkin'),
  newParticipant(3, 'josh-ren-blu'),
  // newParticipant(4, 'josh-ren-blu'),
  // newParticipant(5, 'josh-ren-blu'),
  // newParticipant(6, 'josh-ren-blu'),
]
let state = { type: "mediaList", list: participants }

const dom = ReactDOM.render(
  <App state={state} setFeatured={setFeatured}/>,
  document.getElementById('root')
);

function setFeatured(participant) {
  participants.forEach(p => p.featured = false)
  participant.featured = true
  dom.forceUpdate()
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
