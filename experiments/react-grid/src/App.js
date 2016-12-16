import React, { Component } from 'react'
import logo from './logo.svg'
import './App.css'

class FeaturedMedia extends Component {
  render() {
    return <Participant participant={this.props.participant} />
  }
}

class Participant extends Component {
  render() {
    return <div className="Featured">
      {this.props.participant.identity}
    </div>
  }
}

class MediaGrid extends Component {
  render() {
    console.log(this.props.participants)
    const media = this.props.participants.map(p => <Participant participant={p} />)
    return <div className="Participants">{media}</div>
  }
}

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

export default App
