import { UiFlex } from '../../../ui/ui-flex/UiFlex';
import { UiSpace } from '../../../ui/ui-space/UiSpace';
import { UiTextButton } from '../../../ui/UiTextButton/UiTextButton';
import { useFlightListItemStyles } from './FlightListItem.styles';

interface IProps {}

export const FlightListItem: React.FC<IProps> = (props) => {
  const { classes } = useFlightListItemStyles();

  return (
    <li className={classes.root}>
      <UiFlex columnGap={10} style={{ border: '1px solid dodgerblue' }}>
        <div style={{ border: '1px solid red' }}>PILOT</div>
        <div style={{ border: '1px solid orange' }}>
          <UiFlex columnGap={5}>
            <div>DEPARTURE TIME</div>
            <div>DURATION</div>
            <div>ARRIVAL TIME</div>
          </UiFlex>

          <UiSpace h={10} />

          <UiFlex columnGap={5}>
            <UiTextButton radius={'sm'} size={'xs'}>
              Flight Details
            </UiTextButton>
            <UiTextButton radius={'sm'} size={'xs'}>
              Fare Info
            </UiTextButton>
            <UiTextButton radius={'sm'} size={'xs'}>
              Refund
            </UiTextButton>
          </UiFlex>
        </div>
        <div style={{ border: '1px solid green' }}>
          <div>
            Start From
            <div>PRICE</div>
            <UiTextButton>View Deals</UiTextButton>
          </div>
          <div>
            Scan Me
            <div>QR CODE</div>
          </div>
        </div>
      </UiFlex>
    </li>
  );
};

FlightListItem.displayName = 'FlightListItem';
