import React from 'react';
import { Marker } from 'react-leaflet';
import { Icon } from 'leaflet';
import icon from '../icons/marker.png';
import shadow from '../icons/shadow.png';

const targetIcon = new Icon({
  iconUrl: icon,
  iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	tooltipAnchor: [16, -28],
	shadowSize:  [41, 41],
  shadowUrl: shadow,
});

const TargetMarker = (props) => (
  <Marker
    icon={targetIcon}
    draggable
    zIndexOffset={500}
    {...props}
  />
);

export default TargetMarker;
