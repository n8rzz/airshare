import react from "react";
import { UiFlex } from "../../ui/ui-flex/UiFlex";
import { UiSpace } from "../../ui/ui-space/UiSpace";
import { UiTextButton } from "../../ui/UiTextButton/UiTextButton";
import { FlightListItem } from "./flight-list-item/FlightListItem";

interface IProps {}

export const FlightsPage: React.FC<IProps> = (props) => {
  // const mockListItems =

  return (
    <div>
      <div>CURRENT SEARCH PARAMS</div>
      <div>HERO</div>

      <div>
        <div>LEFT - FILTERS</div>
      </div>

      <ul>
        {[...Array(10)].map((v, i) => (
          <FlightListItem key={i} />
        ))}
      </ul>

      <UiTextButton>Load More</UiTextButton>
    </div>
  );
};

FlightsPage.displayName = "FlightsPage";
