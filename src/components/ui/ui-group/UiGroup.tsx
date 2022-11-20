import { Group, Button, GroupProps } from "@mantine/core";

interface IProps extends GroupProps {}

export const UiGroup: React.FC<IProps> = (props) => {
  return <Group {...props} />;
};

UiGroup.displayName = "UiGroup";
