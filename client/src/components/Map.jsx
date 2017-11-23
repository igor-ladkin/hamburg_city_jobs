import React, { Component } from 'react';
import { Map as LeafletMap, Popup, TileLayer, Marker } from 'react-leaflet';
import TargetMarker from './TargetMarker';

class Map extends Component {
  constructor() {
    super();

    this.state = {
      zoom: 15,
      center: {
        lat: 53.5563943,
        lng: 9.9882726,
      },
      position: {
        lat: 53.5563943,
        lng: 9.9882726,
      },
    };

    this.updateLocation = this.updateLocation.bind(this);
  }

  updateLocation(event) {
    const newLocation = event.target._latlng;

    console.log(newLocation);
    this.setState({position: newLocation});
  }

  renderBranch({ id, company, address, location }) {
    const position = [location.lat, location.lng];

    return (
      <Marker key={id} position={position}>
        <Popup>
          <div>
            <div>{company}</div>
            <div>{address}</div>
          </div>
        </Popup>
      </Marker>
    )
  }

  renderBranches() {
    const { branches } = this.props;
    return branches.map(this.renderBranch)
  }

  render() {
    const center = [this.state.center.lat, this.state.center.lng];
    const position = [this.state.position.lat, this.state.position.lng];

    return (
      <LeafletMap center={center} zoom={this.state.zoom} className='map'>
        <TileLayer url='http://{s}.tile.osm.org/{z}/{x}/{y}.png' />
        <TargetMarker position={position} onDragEnd={this.updateLocation}>
          <Popup>
            <span>A pretty CSS3 popup. <br/> Easily customizable.</span>
          </Popup>
        </TargetMarker>
        {this.renderBranches()}
      </LeafletMap>
    )
  }
}

export default Map;
