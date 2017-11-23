import React, { Component } from 'react';
import { Container } from 'semantic-ui-react';
import 'semantic-ui-css/semantic.min.css';
import './App.css';

import Header from './components/Header';
import Map from './components/Map';
import Search from './components/Search';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      branches: [],
    };
  }

  componentDidMount() {
    fetch('/api/search')
      .then(resp => resp.json())
      .then(({ data }) => {
        this.setState({branches: data});
      })
  }

  render() {
    const { branches } = this.state;

    return (
      <Container fluid>
        <Header />
        <Map branches={branches} />
        <Search />
      </Container>
    );
  }
}

export default App;
