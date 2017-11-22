import React, { Component } from 'react';
import { Map as LeafletMap, Popup, TileLayer } from 'react-leaflet';
import TargetMarker from './TargetMarker';

class Map extends Component {
  constructor() {
    super();

    this.state = {
      zoom: 14,
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
      </LeafletMap>
    )
  }
}

export default Map;
