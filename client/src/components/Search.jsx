import React, { Component } from 'react';
import { Segment, Form } from 'semantic-ui-react';

class Search extends Component {
  render() {
    return (
      <Segment className='search'>
        <Form>
          <Form.Input label='Company' placeholder='Nike' />
          <Form.Input label='Radius' placeholder='500' />
        </Form>
      </Segment>
    );
  }
}

export default Search;
