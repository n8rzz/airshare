import { createStyles, SegmentedControl } from "@mantine/core";
import { useUiSegmentedControlStyles } from "./UiSegmentedControl.styles";

interface IProps extends React.ComponentProps<typeof SegmentedControl> {}

export const UiSegmentedControl: React.FC<IProps> = (props) => {
  const { data = [], radius = "sm", size = "md" } = props;
  const { classes } = useUiSegmentedControlStyles();

  return (
    <SegmentedControl
      radius={radius}
      size={size}
      data={data}
      classNames={classes}
    />
  );
};

UiSegmentedControl.displayName = "UiSegmentedControl";
