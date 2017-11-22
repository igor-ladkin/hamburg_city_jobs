import React from 'react';
import { Container, Menu, Image } from 'semantic-ui-react'

import logo from '../logo.png';

const Header = () => (
  <Menu fixed='top' secondary pointing>
    <Container>
      <Menu.Item header>
        <Image
          size='mini'
          src={logo}
          style={{ marginRight: '1.5em' }}
        />
        Hamburg City Jobs
      </Menu.Item>
    </Container>
  </Menu>
);

export default Header;
