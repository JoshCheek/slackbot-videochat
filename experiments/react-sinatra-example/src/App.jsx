import '../lib/app/public/styles.css';
import React from 'react';
import ReactDOM from 'react-dom';

var App = React.createClass({

  render: function() {
    return(<p>Hello from JavaScript!</p>)
  }

});

ReactDOM.render(<App />, document.getElementById('root'))
