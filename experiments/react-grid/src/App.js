import React, { Component } from 'react'
import './App.css'

class App extends Component {
  render() {
    const list     = this.props.state.list
    const featured = list.find(p => p.featured) || list[0] || this.nullParticipant()
    return <div className="App">
      <FeaturedMedia participant={featured} />
      <MediaGrid participants={list} setFeatured={this.props.setFeatured}/>
    </div>
  }

  nullParticipant() {
    return { identity: '', media: 'null media', connected: false }
  }
}


class FeaturedMedia extends Component {
  render() {
    return <div className="Featured">
      <Media participant={this.props.participant} />
    </div>
  }
}

class MediaGrid extends Component {
  render() {
    console.log(this.props.participants)
    const media = this.props.participants.map(p => <Media key={p.identity} participant={p} />)
    return <div className="Participants">{media}</div>
  }
}

class Media extends Component {
  render() {
    const url = this.props.participant.media.url
    return <img className="media" src={url} />
  }
}

export default App
