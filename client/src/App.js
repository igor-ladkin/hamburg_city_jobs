import React, { Component } from 'react';
import { Container } from 'semantic-ui-react';
import 'semantic-ui-css/semantic.min.css';
import './App.css';

import Header from './components/header';

class App extends Component {
  render() {
    return (
      <Container fluid>
        <Header />
      </Container>
    );
  }
}

export default App;
