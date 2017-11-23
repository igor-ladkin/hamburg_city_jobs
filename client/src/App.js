import React, { Component } from 'react';
import { Container } from 'semantic-ui-react';
import qs from 'qs';
import _ from 'lodash';
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
      radius: '',
      distancePT: '',
      companyName: '',
      targetPosition: {
        lat: 53.5563943,
        lng: 9.9882726,
      },
    };

    this.fetchBranches = _.debounce(this.fetchBranches.bind(this), 200);
    this.updateLocation = this.updateLocation.bind(this);
    this.updateSearchField = this.updateSearchField.bind(this);
  }

  fetchBranches() {
    const searchParams = _.pick(this.state, ['targetPosition', 'radius', 'companyName', 'distancePT']);
    const params = qs.stringify(searchParams);

    fetch(`/api/search?${params}`)
      .then(resp => resp.json())
      .then(({ data }) => {
        this.setState({branches: data});
      });
  }

  componentDidMount() {
    this.fetchBranches();
  }

  updateSearchField(name, value) {
    console.log(`${name}: ${value}`);
    this.setState({[name]: value});
    this.fetchBranches();
  }

  updateLocation(event) {
    const newLocation = event.target.getLatLng();

    console.log(newLocation);
    this.setState({targetPosition: newLocation});
    this.fetchBranches();
  }

  render() {
    const { branches, targetPosition, companyName, radius } = this.state;

    return (
      <Container fluid>
        <Header />
        <Map
          branches={branches}
          targetPosition={targetPosition}
          updateLocation={this.updateLocation}
          fetchBranches={this.fetchBranches}
        />
        <Search
          companyName={companyName}
          radius={radius}
          fetchBranches={this.fetchBranches}
          updateSearchField={this.updateSearchField}
        />
      </Container>
    );
  }
}

export default App;
