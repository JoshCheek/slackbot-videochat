var videoClient;
var activeRoom;
var previewMedia;
var roomName;
var toDetach = [];

// room.localParticipant
// participant.identity
// participant.media
// media.attach(div);
// media.detach();


// Check for WebRTC
if (!navigator.webkitGetUserMedia && !navigator.mozGetUserMedia) {
  alert('WebRTC is not available in your browser.');
}

window.addEventListener('beforeunload', function() {
  activeRoom && activeRoom.disconnect()
});

$.getJSON('/token', function (data) {
  videoClient = new Twilio.Video.Client(data.token);
  document.getElementById('room-controls').style.display = 'block';
  document.getElementById('button-join').onclick = function () {
    roomName = document.getElementById('room-name').value
    videoClient.connect({to: roomName}).then(roomJoined, function(error) { alert(error.toString()) });
  }
  document.getElementById('button-leave').onclick = function () { activeRoom.disconnect() }
});


document.getElementById('button-preview').onclick = function () {
  ensurePreview()
};

function ensurePreview() {
  if(previewMedia) return
  previewMedia = new Twilio.Video.LocalMedia();
  Twilio.Video.getUserMedia().then(
    function (mediaStream) {
      previewMedia.addStream(mediaStream);
      previewMedia.attach('#local-media');
      toDetach.push(previewMedia)
    },
    function (error) { alert(error.toString()) }
  )
}

function detachAll() {
  while(toDetach.length)
    toDetach.pop().detach()
}

function roomJoined(room) {
  activeRoom = room

  document.getElementById('button-join').style.display = 'none';
  document.getElementById('button-leave').style.display = 'inline';

  ensurePreview()

  room.participants.forEach(function(participant) {
    participant.media.attach('#remote-media');
    toDetach.push(participant.media)
  });
  room.on('participantConnected', function (participant) {
    participant.media.attach('#remote-media');
    toDetach.push(participant.media)
  });
  room.on('participantDisconnected', function (participant) {
    participant.media.detach()
  });
  room.on('disconnected', function () {
    detachAll()
    activeRoom = null
    document.getElementById('button-join').style.display = 'inline';
    document.getElementById('button-leave').style.display = 'none';
  })
}

