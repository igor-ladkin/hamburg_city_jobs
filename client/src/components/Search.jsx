import React, { Component } from 'react';
import { Segment, Form } from 'semantic-ui-react';

class Search extends Component {
  render() {
    const { companyName, radius, updateSearchField } = this.props;

    return (
      <Segment className='search'>
        <Form>
          <Form.Input
            label='Company'
            placeholder='Nike'
            value={companyName}
            onChange={(e) => updateSearchField('companyName', e.target.value)}
          />
          <Form.Input
            label='Radius'
            placeholder='500'
            value={radius}
            onChange={(e) => updateSearchField('radius', e.target.value)}
          />
        </Form>
      </Segment>
    );
  }
}

export default Search;
