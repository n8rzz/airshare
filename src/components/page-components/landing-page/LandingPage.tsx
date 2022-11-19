import react from "react";

interface IProps {}

export const LandingPage: React.FC<IProps> = (props) => {
  return (
    <div>
      <h2>Airshare.com</h2>
      <h3>Search Flights</h3>
      <button>Flind Flights</button>
    </div>
  );
};

LandingPage.displayName = "LandingPage";
