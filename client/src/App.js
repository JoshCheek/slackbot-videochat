import React, { Component } from 'react'
import './App.css'

class App extends Component {
  render() {
    const list     = this.props.state.list
    const featured = list.find(p => p.featured) || list[0]
    return <div className="App">
      <div className="FeaturedPanel">
        <FeaturedMedia participant={featured} />
      </div>
      <div className="Separator" />
      <div className="ListPanel">
        <MediaList participants={list} setFeatured={this.props.setFeatured}/>
      </div>
    </div>
  }
}


class FeaturedMedia extends Component {
  render() {
    let media
    if(this.props.participant)
      media = <Media participant={this.props.participant} />
    return <div className="Featured">{media}</div>
  }
}

class MediaList extends Component {
  render() {
    const media = this.props.participants.map(p =>
      <Media key={p.identity} participant={p} setFeatured={this.props.setFeatured}/>
    )
    return <div className="List">{media}</div>
  }
}

class Media extends Component {
  render() {
    const participant = this.props.participant
    return <div
      className="Media"
      ref={(div) => {
        console.log(`${participant.identity} is attaching`)
        participant.media.attach(div)
      }}
      onClick={() => this.props.setFeatured(participant)}
    />
  }
}

export default App
