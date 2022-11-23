import { DatePicker, DatePickerProps } from '@mantine/dates';
import { useUiDatePickerStyles } from './UiDatePicker.styles';

interface IProps extends DatePickerProps {
  /**
   * @optional
   * @default false
   */
  clearable?: boolean;
}

export const UiDatePicker: React.FC<IProps> = (props) => {
  const {
    clearable = true,
    label = '',
    placeholder = '',
    ...componentProps
  } = props;
  const { classes } = useUiDatePickerStyles();

  return (
    <DatePicker
      {...componentProps}
      classNames={classes}
      clearable={clearable}
      label={label}
      placeholder={placeholder}
    />
  );
};

UiDatePicker.displayName = 'UiDatePicker';
