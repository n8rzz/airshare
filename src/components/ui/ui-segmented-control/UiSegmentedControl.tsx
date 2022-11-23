import { SegmentedControl, SegmentedControlProps } from '@mantine/core';
import { useUiSegmentedControlStyles } from './UiSegmentedControl.styles';

interface IProps extends SegmentedControlProps {}

export const UiSegmentedControl: React.FC<IProps> = (props) => {
  const { data = [], radius = 'sm', size = 'md' } = props;
  const { classes } = useUiSegmentedControlStyles();

  return (
    <SegmentedControl
      classNames={classes}
      data={data}
      radius={radius}
      size={size}
    />
  );
};

UiSegmentedControl.displayName = 'UiSegmentedControl';
