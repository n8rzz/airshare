import React from 'react';
import { Title, TitleProps } from '@mantine/core';

interface IProps extends TitleProps {
}

export const UiTitle: React.FC<IProps> = (props) => {
  return <Title {...props} />
};

UiTitle.displayName = 'UiTitle';
