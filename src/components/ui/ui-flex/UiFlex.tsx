import React from 'react';
import { Flex, FlexProps } from '@mantine/core';

interface IProps extends Omit<FlexProps, 'align'> {
  /**
   * @optional
   * @default flex-start
   */
  alignItems?: FlexProps['align'];
}

export const UiFlex: React.FC<IProps> = (props) => {
  const { alignItems = 'flex-start', justify = 'flex-start', ...componentProps } = props;

  return (
    <Flex
      {...componentProps}
      align={alignItems}
      justify={justify}
    />
  );
};
