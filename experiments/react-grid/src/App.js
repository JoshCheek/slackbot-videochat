import React, { Component } from 'react'
import logo from './logo.svg'
import './App.css'

class FeaturedMedia extends Component {
}

class MediaGrid extends Component {
}

class App extends Component {
  render() {
    // <FeaturedMedia />
    // <MediaGrid />
    const listItems = this.props.state.list.map(p => <li>{p.identity}</li>)
    return <div className="App">
      <ul>{listItems}</ul>
    </div>
  }
}

export default App
