/* eslint-disable @next/next/no-page-custom-font */
import React from 'react';

interface IProps {
}

export const Fonts: React.FC<IProps> = (props) => {
  return (
    <style>
      {/** @link https://fonts.google.com/specimen/Merriweather?preview.text=Departure%20Destination%20Flight%20Schedule%20Airplane%20Jetway%20Taxi%20ATIS%20METAR%20Passenger%20AirShare%201234567890%20!%3F.%22%20%27%20%20$1,00.00%20&preview.size=16&preview.text_type=custom&category=Serif,Sans+Serif,Handwriting,Monospace*/}
      <link
        href={'https://fonts.googleapis.com'}
        rel={'preconnect'}
      />
      <link
        crossOrigin={'true'}
        href={'https://fonts.gstatic.com'}
        rel={'preconnect'}
      />
      <link
        href={'https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,400;0,900;1,400&display=swap'}
        rel={'stylesheet'}
      />

      {/** @link https://fonts.google.com/specimen/Barlow?preview.text=Departure%20Destination%20Flight%20Schedule%20Airplane%20Jetway%20Taxi%20ATIS%20METAR%20Passenger%20AirShare%201234567890%20!%3F.%22%20%27%20%20$1,00.00%20&preview.size=16&preview.text_type=custom&category=Serif,Sans+Serif,Handwriting,Monospace */}
      <link
        href={'https://fonts.googleapis.com'}
        rel={'preconnect'}
      />
      <link
        crossOrigin={'true'}
        href={'https://fonts.gstatic.com'}
        rel={'preconnect'}
      />
      <link
        href={'https://fonts.googleapis.com/css2?family=Barlow:ital,wght@0,100;0,400;0,600;0,800;1,400&display=swap'}
        rel={'stylesheet'}
      />
    </style>
  );
};
