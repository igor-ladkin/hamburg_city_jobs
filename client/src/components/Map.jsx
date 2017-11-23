import React, { Component } from 'react';
import { Map as LeafletMap, Popup, TileLayer, Marker } from 'react-leaflet';
import TargetMarker from './TargetMarker';
import StopMarker from './StopMarker';

class Map extends Component {
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

    renderStop({ id, name, location }) {
        const position = [location.lat, location.lng];

        return (
            <StopMarker key={id} position={position}>

            </StopMarker>
        )
    }

  renderBranches() {
    const { branches } = this.props;
    return branches.map(this.renderBranch)
  }

  renderStops() {
    const {stops} = this.props;
    return stops.map(this.renderStop)
  }

  render() {
    const { updateLocation, targetPosition } = this.props;
    const center = [53.5511, 9.9937];

    return (
      <LeafletMap center={center} zoom={15} className='map'>
        <TileLayer url='http://{s}.tile.osm.org/{z}/{x}/{y}.png' />
        <TargetMarker position={targetPosition} onDragEnd={updateLocation}>
          <Popup>
            <span>A pretty CSS3 popup. <br/> Easily customizable.</span>
          </Popup>
        </TargetMarker>
        {this.renderBranches()}
        {this.renderStops()}
      </LeafletMap>
    )
  }
}

export default Map;
