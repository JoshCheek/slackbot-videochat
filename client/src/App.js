// https://slackbot-videochat.herokuapp.com/videochats/token
import React, { Component } from 'react'
import './App.css'

class App extends Component {
  render() {
    const list     = this.props.state.list
    const featured = list.find(p => p.featured) || list[0]
    console.log({ featured: featured.identity })
    return <div className="App">
      <div className="FeaturedPanel">
        <FeaturedMedia participant={featured} key={featured && featured.identity} />
      </div>
      <div className="Separator" />
      <div className="ListPanel">
        <MediaList participants={list} setFeatured={this.props.setFeatured}/>
      </div>
    </div>
  }
}


// https://slackbot-videochat.herokuapp.com/videochats/token
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
  componentDidMount() {
    this.props.participant.media.attach(
      this.refs.container
    )
  }

  componentWillUnmount() {
    this.props.participant.media.detach()
  }

  render() {
    const participant = this.props.participant
    return <div
      className="Media"
      ref="container"
      onClick={() => this.props.setFeatured(participant)}
    />
  }
}

export default App
