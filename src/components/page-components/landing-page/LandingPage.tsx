import react from "react";
import { UiDatePicker } from "../../ui/ui-date-picker/UiDatePicker";
import { UiSegmentedControl } from "../../ui/ui-segmented-control/UiSegmentedControl";
import { UiTextInput } from "../../ui/ui-text-input/UiTextInput";

interface IProps {}

export const LandingPage: React.FC<IProps> = (props) => {
  return (
    <div>
      <h2>Airshare.com</h2>
      <h3>Search Flights</h3>
      <div>
        <UiSegmentedControl data={["Round Trip", "One Way"]} />
      </div>
      <div>
        <UiTextInput label={"Departure City"} />
        <UiTextInput label={"Arrival City"} />
      </div>
      <div>
        <UiDatePicker clearable={true} label={"Departure Date"} />
      </div>
    </div>
  );
};

LandingPage.displayName = "LandingPage";
