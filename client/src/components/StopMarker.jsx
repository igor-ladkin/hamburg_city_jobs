import React from 'react';
import { Marker } from 'react-leaflet';
import { Icon } from 'leaflet';
import icon from '../icons/stop.png';

const targetIcon = new Icon({
  iconUrl: icon,
  iconSize: [16, 16],
  iconAnchor: [0,0],
  tooltipAnchor: [16, -28],
});

const StopMarker = (props) => (
  <Marker
    icon={targetIcon}
    zIndexOffset={20}
    {...props}
  />
);

export default StopMarker;
