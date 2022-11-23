import React from 'react';
import { UiTextButton } from '../../ui/UiTextButton/UiTextButton';
import { FlightListItem } from './flight-list-item/FlightListItem';

interface IProps {
}

export const FlightsPage: React.FC<IProps> = (props) => {
  return (
    <div>
      <div>CURRENT SEARCH PARAMS</div>
      <div>HERO</div>

      <div>
        <div>LEFT - FILTERS</div>
      </div>

      <ul>
        {[...Array(10)].map((_, index) => (
          <FlightListItem key={index}/>
        ))}
      </ul>

      <UiTextButton>Load More</UiTextButton>
    </div>
  );
};

FlightsPage.displayName = 'FlightsPage';
